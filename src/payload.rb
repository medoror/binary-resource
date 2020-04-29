class Payload

  attr_accessor :owner
  attr_accessor :repo
  attr_accessor :tag

  def initialize(payload)
    payload_split = payload["source"]["repo"].split("/")
    @owner = payload_split[0]
    @repo = payload_split[1]
    @tag = payload["source"]["tag"]
  end
end