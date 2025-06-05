require 'strava/api/client'

class StravaClient
  def initialize(access_token: ENV['STRAVA_ACCESS_TOKEN'])
    @client = Strava::Api::Client.new(access_token: access_token)
  end

  def athlete
    @client.athlete
  end
end
