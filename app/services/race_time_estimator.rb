class RaceTimeEstimator
  # Fatigue coefficients used to slightly slow the pace as distance and
  # elevation accumulate. Values were lowered to avoid overestimating the
  # effect of fatigue on long routes.
  DISTANCE_FATIGUE_RATE = 0.002
  UPHILL_FATIGUE_RATE  = 0.000015
  DOWNHILL_FATIGUE_RATE = 0.000015
  FATIGUE_EXPONENT      = 1.1

  def initialize(segments, pace_source)
    @segments = segments
    @paces = pace_source
  end

  def total_seconds
    dist_accum = 0.0
    pos_accum = 0.0
    neg_accum = 0.0
    total = 0.0
    @segments.each do |seg|
      total += segment_time(seg, dist_accum, pos_accum, neg_accum)
      dist_accum += seg.distance_km
      pos_accum += seg.elevation_gain_m
      neg_accum += seg.elevation_loss_m
    end
    total.to_i
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
    prev_dist = 0.0
    prev_pos = 0.0
    prev_neg = 0.0

    @segments.each do |seg|
      seg_time = segment_time(seg, dist_accum, pos_accum, neg_accum)

      while time_accum + seg_time >= next_mark
        ratio = (next_mark - time_accum) / seg_time
        dist = dist_accum + seg.distance_km * ratio
        pos = pos_accum + seg.elevation_gain_m * ratio
        neg = neg_accum + seg.elevation_loss_m * ratio

        progress << [
          next_mark / 3600,
          dist.round(2),
          (dist - prev_dist).round(2),
          (pos - prev_pos).round(1),
          (neg - prev_neg).round(1)
        ]

        prev_dist = dist
        prev_pos = pos
        prev_neg = neg
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
    pos_accum = 0.0
    neg_accum = 0.0
    next_km = 1.0

    @segments.each do |seg|
      seg_time = segment_time(seg, dist_accum, pos_accum, neg_accum)

      while dist_accum + seg.distance_km >= next_km
        ratio = (next_km - dist_accum) / seg.distance_km
        marks << [next_km.round, (time_accum + seg_time * ratio).to_i]
        next_km += 1.0
      end

      time_accum += seg_time
      dist_accum += seg.distance_km
      pos_accum += seg.elevation_gain_m
      neg_accum += seg.elevation_loss_m
    end

    marks
  end

  private

  def pace_for_grade(grade)
    if @paces.respond_to?(:predict)
      @paces.predict(grade)
    else
      return @paces[:uphill] if grade > 0.03
      return @paces[:downhill] if grade < -0.03
      @paces[:flat]
    end
  end

  def segment_time(seg, dist_before, pos_before, neg_before)
    pace = pace_for_grade(seg.grade)
    fatigue = 1.0 + DISTANCE_FATIGUE_RATE * (dist_before ** FATIGUE_EXPONENT)
    if seg.grade > 0.03
      fatigue += UPHILL_FATIGUE_RATE * (pos_before ** FATIGUE_EXPONENT)
    elsif seg.grade < -0.03
      fatigue += DOWNHILL_FATIGUE_RATE * (neg_before ** FATIGUE_EXPONENT)
    end
    seg.distance_km * pace * fatigue * 60
  end
end
