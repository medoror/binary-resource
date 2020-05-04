#!/usr/bin/env ruby
require_relative './payload'
require 'tty-command'
require_relative './http_client'


class In < Payload

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
  # {
  #     "version": { "version":"4.6.0"},
  #     "metadata":[]
  # }
  attr_accessor :version

  def initialize(payload)
    super
    @version = payload["version"]["version"]
  end

  def create_dest_dir(destinator_dir)
    created_dir = FileUtils.mkdir_p "#{destinator_dir}#{@repo}"
    created_dir[0]
  end

  def get_download_link(payload)
    # explicitly check for linux binary until we inject distro choice from recipe
    begin
      payload["assets"].find {|asset| asset["name"].match?(/.*linux.*gz/)}["browser_download_url"]
    rescue NoMethodError => e
      raise "Download Link could not be retrieved"
    end
  end

  def main(destination_dir)
    response = HttpClient.get("https://api.github.com/repos/#{@owner}/#{@repo}/releases/tags/#{@version}")

    download_link = get_download_link(response)

    full_destination = create_dest_dir(destination_dir)

    download_binary(download_link, full_destination)

    output_to_stdout(@version)

  end

  private

  def output_to_stdout(download_name)

    output = {"version" => { "version" => download_name}, "metadata" => []}
    puts output.to_json
  end

  def download_binary(download_link, full_destination)
    cmd = TTY::Command.new
    cmd.run("wget -q #{download_link} -P #{full_destination}")
  end
end


# In.new(JSON.parse(STDIN.read)).main(ARGV[0])