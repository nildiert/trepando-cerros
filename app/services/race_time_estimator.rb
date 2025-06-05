class RaceTimeEstimator
  def initialize(segments, paces_by_grade)
    @segments = segments
    @paces = paces_by_grade
  end

  def total_seconds
    @segments.sum do |seg|
      pace = pace_for_grade(seg.grade)
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

  def pace_for_grade(grade)
    return @paces[:uphill] if grade > 0.03
    return @paces[:downhill] if grade < -0.03
    @paces[:flat]
  end
end
