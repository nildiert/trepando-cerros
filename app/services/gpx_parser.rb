require 'nokogiri'

class GpxParser
  Segment = Struct.new(:distance_km, :elevation_gain_m, :elevation_loss_m, :grade)

  EARTH_RADIUS_KM = 6371.0

  def initialize(io)
    io.rewind if io.respond_to?(:rewind)
    @doc = Nokogiri::XML(io)
    @doc.remove_namespaces!
  end

  def segments
    points = @doc.xpath('//trkpt').map do |pt|
      {
        lat: pt['lat'].to_f,
        lon: pt['lon'].to_f,
        ele: pt.at_xpath('ele')&.content.to_f
      }
    end
    segs = []
    points.each_cons(2) do |a, b|
      dist = distance(a, b)
      delta = b[:ele] - a[:ele]
      gain = delta.positive? ? delta : 0
      loss = delta.negative? ? delta.abs : 0
      segs << Segment.new(dist, gain, loss, grade(a, b, dist))
    end
    segs
  end

  def elevation_profile
    points = @doc.xpath('//trkpt').map do |pt|
      {
        lat: pt['lat'].to_f,
        lon: pt['lon'].to_f,
        ele: pt.at_xpath('ele')&.content.to_f
      }
    end
    return { distance_km: [], elevation_m: [] } if points.empty?

    distances = [0.0]
    elevations = [points.first[:ele]]
    total = 0.0
    points.each_cons(2) do |a, b|
      total += distance(a, b)
      distances << total.round(2)
      elevations << b[:ele]
    end
    { distance_km: distances, elevation_m: elevations }
  end

  private

  def distance(a, b)
    lat1 = to_rad(a[:lat])
    lat2 = to_rad(b[:lat])
    dlat = lat2 - lat1
    dlon = to_rad(b[:lon] - a[:lon])
    h = Math.sin(dlat / 2)**2 + Math.cos(lat1) * Math.cos(lat2) * Math.sin(dlon / 2)**2
    2 * EARTH_RADIUS_KM * Math.atan2(Math.sqrt(h), Math.sqrt(1 - h))
  end

  def elevation_gain(a, b)
    gain = b[:ele] - a[:ele]
    gain.positive? ? gain : 0
  end

  def grade(a, b, dist_km)
    delta = b[:ele] - a[:ele]
    meters = dist_km * 1000.0
    return 0 if meters.zero?
    delta / meters
  end

  def to_rad(deg)
    deg * Math::PI / 180.0
  end
end
