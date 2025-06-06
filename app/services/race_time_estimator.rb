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

  def progress_by_hour
    progress = []
    time_accum = 0.0
    dist_accum = 0.0
    pos_accum = 0.0
    neg_accum = 0.0
    next_mark = 3600.0

    @segments.each do |seg|
      pace = pace_for_grade(seg.grade)
      seg_time = seg.distance_km * pace * 60

      while time_accum + seg_time >= next_mark
        ratio = (next_mark - time_accum) / seg_time
        dist = dist_accum + seg.distance_km * ratio
        pos = pos_accum + seg.elevation_gain_m * ratio
        neg = neg_accum + seg.elevation_loss_m * ratio
        prev = progress.last
        progress << [
          next_mark / 3600,
          dist.round(2),
          (prev ? (dist - prev[1]) : dist).round(2),
          (prev ? (pos - prev[3]) : pos).round(1),
          (prev ? (neg - prev[4]) : neg).round(1)
        ]
        next_mark += 3600.0
      end

      time_accum += seg_time
      dist_accum += seg.distance_km
      pos_accum += seg.elevation_gain_m
      neg_accum += seg.elevation_loss_m
    end

    progress
  end

  def time_per_km
    marks = []
    time_accum = 0.0
    dist_accum = 0.0
    next_km = 1.0

    @segments.each do |seg|
      pace = pace_for_grade(seg.grade)
      seg_time = seg.distance_km * pace * 60

      while dist_accum + seg.distance_km >= next_km
        ratio = (next_km - dist_accum) / seg.distance_km
        marks << [next_km.round, (time_accum + seg_time * ratio).to_i]
        next_km += 1.0
      end

      time_accum += seg_time
      dist_accum += seg.distance_km
    end

    marks
  end

  private

  def pace_for_grade(grade)
    return @paces[:uphill] if grade > 0.03
    return @paces[:downhill] if grade < -0.03
    @paces[:flat]
  end
end
