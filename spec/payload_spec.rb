require 'json'

describe "payload" do

  context "#initalize" do
    it "sets tag and download link if passed in from json" do
      payload = <<JSON
      {
        "source": {
        "repo": "pivotal-cf/om",
        "tag": "latest"
      },
        "version": {
          "version": "4.6.0"
      }
    }
JSON
      payload = Payload.new(JSON.parse(payload))
      expect(payload.owner).to eq "pivotal-cf"
      expect(payload.repo).to eq "om"
      expect(payload.tag).to eq "latest"
    end
  end
end
