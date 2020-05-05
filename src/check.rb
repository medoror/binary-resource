#!/usr/bin/env ruby
require_relative './payload'
require_relative './http_client'

class Check < Payload

  # STDIN:
  # {
  #     "source": {
  #     "repo": "pivotal-cf/om",
  #     "tag": "4.6.0"
  # },
  #     "version": { "version": "4.6.0" }
  # }
  #
  # STDOUT
  # [{"version":"4.6.0"}]

  def pull_latest_versions
    if @tag == "latest"
      response = HttpClient.get("https://api.github.com/repos/#{@owner}/#{@repo}/releases")
      response[0]["name"]
    else
      @tag
    end
  end

  def main
    results = {"version" => pull_latest_versions}
    to_array = [results].to_json
    puts to_array
  end
end

Check.new(JSON.parse(ARGF.read)).main