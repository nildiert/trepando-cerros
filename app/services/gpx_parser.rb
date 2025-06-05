require 'nokogiri'

class GpxParser
  Segment = Struct.new(:distance_km, :elevation_gain_m)

  EARTH_RADIUS_KM = 6371.0

  def initialize(io)
    @doc = Nokogiri::XML(io)
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
      segs << Segment.new(distance(a, b), elevation_gain(a, b))
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

  def to_rad(deg)
    deg * Math::PI / 180.0
  end
end
