#!/usr/bin/env ruby
require_relative './payload'
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

  def main
    # read version
    # download the given version
    # unpack tar and place in in bin dir
  end
end


# In.new(JSON.parse(ARGF.read)).main