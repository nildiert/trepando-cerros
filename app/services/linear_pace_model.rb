class LinearPaceModel
  def self.train(pairs)
    pairs = pairs.compact
    return nil if pairs.empty?
    x_sum = 0.0
    y_sum = 0.0
    xy_sum = 0.0
    x2_sum = 0.0
    pairs.each do |grade, pace|
      x_sum += grade
      y_sum += pace
      xy_sum += grade * pace
      x2_sum += grade**2
    end
    n = pairs.size
    denom = n * x2_sum - x_sum * x_sum
    return nil if denom.zero?
    slope = (n * xy_sum - x_sum * y_sum) / denom
    intercept = (y_sum - slope * x_sum) / n
    new(intercept, slope)
  end

  def initialize(intercept, slope)
    @intercept = intercept
    @slope = slope
  end

  def predict(grade)
    pace = @intercept + @slope * grade
    pace = 3.0 if pace < 3.0
    pace = 20.0 if pace > 20.0
    pace
  end
end
