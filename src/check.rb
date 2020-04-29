#!/usr/bin/env ruby

require 'json'
require 'net/http'
require 'uri'

class Check

  # STDIN:
  #   "source": {
  #     "repo": "pivotal-cf/om",
  #     "tag": "4.6.0"
  #   },
  #   "version": { "version": 4.6.0 }
  # }
  #
  # STDOUT
  # [
  # {"version": "4.6.0"}
  # ]

  attr_accessor :owner
  attr_accessor :repo
  attr_accessor :tag

  def initialize(payload)
    payload_split = payload["source"]["repo"].split("/")
    @owner = payload_split[0]
    @repo = payload_split[1]
    @tag = payload["source"]["tag"]
  end
  def pull_latest_versions
    uri = URI.parse("https://api.github.com/repos/#{@owner}/#{@repo}/releases")
    response = Net::HTTP.get_response(uri)
    if @tag == "latest"
      response["name"]
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

# Check.new(JSON.parse(ARGF.read)).main 