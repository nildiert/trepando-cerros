require 'nokogiri'

class GpxParser
  Segment = Struct.new(:distance_km, :elevation_gain_m, :grade)

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
      elev_gain = elevation_gain(a, b)
      segs << Segment.new(dist, elev_gain, grade(a, b, dist))
    end
    segs
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
