class RaceTimeEstimator
  def initialize(segments, base_pace_min_per_km)
    @segments = segments
    @base_pace = base_pace_min_per_km.to_f
  end

  def total_seconds
    @segments.sum do |seg|
      pace = adjusted_pace(seg.elevation_gain_m)
      seg.distance_km * pace * 60
    end.to_i
  end

  def formatted_time
    total = total_seconds
    hours = total / 3600
    minutes = (total % 3600) / 60
    secs = total % 60
    format("%02d:%02d:%02d", hours, minutes, secs)
  end

  private

  # Simple adjustment: +0.5 min per km per 100m of climb
  def adjusted_pace(elevation_gain_m)
    @base_pace + (elevation_gain_m / 100.0) * 0.5
  end
end
