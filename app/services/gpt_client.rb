require 'net/http'
require 'uri'
require 'json'

class GptClient
  CHATGPT_MODEL = 'gpt-3.5-turbo'

  def initialize(api_key: ENV['OPENAI_API_KEY'])
    @api_key = api_key
  end

  def chat(message)
    uri = URI.parse('https://api.openai.com/v1/chat/completions')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.request_uri)
    request['Authorization'] = "Bearer #{@api_key}"
    request['Content-Type'] = 'application/json'
    request.body = {
      model: CHATGPT_MODEL,
      messages: [{ role: 'user', content: message }]
    }.to_json

    response = http.request(request)
    JSON.parse(response.body)
  end
end
