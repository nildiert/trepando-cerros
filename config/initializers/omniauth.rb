OmniAuth.config.allowed_request_methods = [:get]

Rails.application.config.middleware.use OmniAuth::Builder do
  google_options = {
    client_id: ENV['GOOGLE_CLIENT_ID'],
    client_secret: ENV['GOOGLE_CLIENT_SECRET']
  }
  callback = ENV['GOOGLE_REDIRECT_URI']
  google_options[:redirect_uri] = callback if callback.present?

  provider :google_oauth2,
           google_options[:client_id],
           google_options[:client_secret],
           google_options.slice(:redirect_uri)
end
