class SessionsController < ApplicationController
  def connect
    client_id = ENV['STRAVA_CLIENT_ID']
    client_secret = ENV['STRAVA_CLIENT_SECRET']
    unless client_id.present? && client_secret.present?
      redirect_to root_path, alert: 'Faltan credenciales STRAVA_CLIENT_ID y STRAVA_CLIENT_SECRET'
      return
    end

    client = Strava::OAuth::Client.new(
      client_id: client_id,
      client_secret: client_secret
    )
    redirect_to client.authorize_url(
      redirect_uri: strava_callback_url,
      response_type: 'code',
      scope: 'activity:read_all'
    )
  end

  def callback
    client_id = ENV['STRAVA_CLIENT_ID']
    client_secret = ENV['STRAVA_CLIENT_SECRET']
    unless client_id.present? && client_secret.present?
      redirect_to root_path, alert: 'Faltan credenciales STRAVA_CLIENT_ID y STRAVA_CLIENT_SECRET'
      return
    end

    client = Strava::OAuth::Client.new(
      client_id: client_id,
      client_secret: client_secret
    )
    token = client.oauth_token(code: params[:code])
    session[:strava_token] = token.access_token
    session[:athlete_id] = token.athlete['id']
    redirect_to athlete_path(token.athlete['id'])
  rescue StandardError
    redirect_to root_path, alert: 'No se pudo autenticar con Strava'
  end
end
