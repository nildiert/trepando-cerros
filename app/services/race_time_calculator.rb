class RaceTimeCalculator
  def initialize(distance_km, pace_min_per_km)
    @distance_km = distance_km
    @pace_min_per_km = pace_min_per_km
  end

  def seconds
    (@distance_km * @pace_min_per_km * 60).to_i
  end

  def formatted_time
    total = seconds
    hours = total / 3600
    minutes = (total % 3600) / 60
    secs = total % 60
    format("%02d:%02d:%02d", hours, minutes, secs)
  end
end
