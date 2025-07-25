class SessionsController < ApplicationController
  def google_connect
    redirect_to '/auth/google_oauth2'
  end

  def google_callback
    auth = request.env['omniauth.auth']
    google_id = auth['uid']
    email = auth['info']['email']
    first_name = auth['info']['first_name']
    last_name = auth['info']['last_name']

    user = User.find_or_initialize_by(google_id: google_id)
    if user.new_record?
      default_role = Role.find_by(name: 'normal')
      user.role = default_role
      user.email = email
      user.save!
      user.create_profile!(first_name: first_name, last_name: last_name)
    elsif user.profile &&
          (user.profile.first_name.blank? || user.profile.last_name.blank?)
      user.profile.update(first_name: first_name, last_name: last_name)
    end

    session[:user_id] = user.id

    redirect_to dashboard_path
  end
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
    redirect_uri = ENV['STRAVA_REDIRECT_URI'].presence ||
                   strava_callback_url(protocol: request.protocol,
                                       host: request.host,
                                       port: request.port)
    redirect_to client.authorize_url(
      redirect_uri: redirect_uri,
      response_type: 'code',
      scope: 'activity:read_all,profile:read_all'
    ), allow_other_host: true
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
    athlete_id = token.athlete['id']

    profile = Profile.find_by(athlete_id: athlete_id)
    user = profile&.user
    unless user
      default_role = Role.find_by(name: 'normal')
      user = User.create!(role: default_role)
      user.create_profile!(athlete_id: athlete_id)
    end

    session[:user_id] = user.id
    session[:strava_token] = token.access_token

    redirect_to athlete_path(athlete_id)
  rescue StandardError
    redirect_to root_path, alert: 'No se pudo autenticar con Strava'
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  def disconnect
    session.delete(:strava_token)
    if current_user
      redirect_to settings_path
    else
      redirect_to root_path
    end
  end
end
