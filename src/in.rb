#!/usr/bin/env ruby
require_relative './payload'
require 'net/http'
require 'uri'
require 'json'
require 'tty-command'

class In < Payload

  # STDIN:
  #   "source": {
  #     "repo": "pivotal-cf/om",
  #     "tag": "4.6.0"
  #   },
  #   "version": { "version": 4.6.0 }
  # }
  #
  # STDOUT
  attr_accessor :version

  def initialize(payload)
    super
    @version = payload["version"]["version"]
  end

  def create_dest_dir(destinator_dir)
    FileUtils.mkdir_p destinator_dir
    File.join(destinator_dir, @repo)
  end

  def get_download_link(payload)
    # explicitly for linux until we inject distro choice from receipe
    begin
      payload["assets"].find { |asset| asset["name"].match?(/.*linux.*gz/)}["browser_download_url"]
    rescue NoMethodError => e
      raise "Download Link could not be retrieved"
    end
  end

  def get_release_by_version
    uri = URI.parse("https://api.github.com/repos/#{@owner}/#{@repo}/releases/tags/#{@version}")
    JSON.parse(Net::HTTP.get_response(uri))
  end

  def main(destination_dir)
    response = get_release_by_version

    download_link = get_download_link(response)
    download_name = download_link.match(/([^\/]+).gz/)[0]

    # download the binary
    wget(download_link, download_name)

    full_destination = create_dest_dir(destination_dir)

    untar_download_to_destination(download_name, full_destination)

  end
  private

  def untar_download_to_destination(download_name, full_destination)
    cmd = TTY::Command.new
    cmd.run("tar -xvfz #{download_name} -C #{full_destination}")
  end

  def wget(url,file)
    unless file
      file = File.basename(url)
    end

    url = URI.parse(url)
    Net::HTTP.start(url.host) do |http|
      resp = http.get(url.path)
      open(file, "wb") do |file|
        file.write(resp.body)
      end
    end
  end
end


# In.new(JSON.parse(ARGF.read)).main(ARGV[0])