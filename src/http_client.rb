require 'json'
require 'net/http'
require 'uri'

class HttpClient
  def self.get(url)
    response =  Net::HTTP.get_response(URI.parse(url))
    return unless response.is_a?(Net::HTTPSuccess)
    JSON.parse(response.body)
  end
end