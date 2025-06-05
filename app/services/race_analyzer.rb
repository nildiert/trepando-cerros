class RaceAnalyzer
  def initialize(gpx_io, strava_client: StravaClient.new)
    @gpx_io = gpx_io
    @strava_client = strava_client
  end

  def estimated_time
    segments = GpxParser.new(@gpx_io).segments
    return nil if segments.empty?

    paces = @strava_client.average_paces_by_grade
    estimator = RaceTimeEstimator.new(segments, paces)
    estimator.formatted_time
  end
end
