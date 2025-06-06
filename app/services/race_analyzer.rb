class RaceAnalyzer
  def initialize(gpx_io, strava_client: StravaClient.new)
    @gpx_io = gpx_io
    @strava_client = strava_client
  end

  def analyze
    parser = GpxParser.new(@gpx_io)
    segments = parser.segments
    return nil if segments.empty?

    pace_source = @strava_client.pace_model || @strava_client.average_paces_by_grade
    estimator = RaceTimeEstimator.new(segments, pace_source)
    {
      time: estimator.formatted_time,
      profile: parser.elevation_profile,
      progress: estimator.progress_by_hour,
      km_seconds: estimator.time_per_km,
      distance: segments.sum(&:distance_km).round(2),
      elevation: segments.sum(&:elevation_gain_m).round(0)
    }
  end

  alias_method :estimated_time, :analyze
end
