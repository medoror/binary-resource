#!/usr/bin/env ruby
require_relative './payload'
require 'tty-command'
require_relative './http_client'

puts __FILE__
puts $PROGRAM_NAME

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

    cmd = TTY::Command.new

    download_binary(download_link, full_destination, cmd)

    untar_binary(download_link.match(/([^\/]+).gz/)[0], full_destination, cmd)

    output_to_stdout(@version)

  end

  private

  def output_to_stdout(download_name)
    output = {"version" => {"version" => download_name}, "metadata" => []}
    puts output.to_json
  end

  def untar_binary(download_name, full_destination, cmd)
    cmd.run("tar -xf #{full_destination}/#{download_name} -C #{full_destination}")
  end

  def download_binary(download_link, full_destination, cmd)
    cmd.run("wget -q #{download_link} -P #{full_destination}")
  end
end

if $PROGRAM_NAME == __FILE__
  standard_input = $stdin.read
  unless standard_input == ''
    in_script = In.new(JSON.parse(standard_input))
    begin
      in_script.main(ARGV[0])
    rescue Errno::ENOENT => e
      STDERR.puts e.message
      exit(1)
    end
  end
end