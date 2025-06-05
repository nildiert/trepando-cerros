class RaceAnalyzer
  def initialize(gpx_io, strava_client: StravaClient.new)
    @gpx_io = gpx_io
    @strava_client = strava_client
  end

  def estimated_time
    segments = GpxParser.new(@gpx_io).segments
    base_pace = @strava_client.average_run_pace
    estimator = RaceTimeEstimator.new(segments, base_pace)
    estimator.formatted_time
  end
end
