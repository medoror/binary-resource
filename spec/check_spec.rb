require_relative '../src/check'
require 'json'

describe "check" do
  context "#pull_latest_versions" do
    it "returns the version of the tag given " do
      allow(Net::HTTP).to receive(:get_response).and_return(nil)
      payload = JSON.parse("{
            \"source\": {
                \"repo\": \"pivotal-cf/om\",
                \"tag\": \"4.4.1\"
            },
            \"version\": {
                \"version\": \"4.4.1\"
            }
        }")

      check = Check.new(payload)
      expect(check.pull_latest_versions).to eq "4.4.1"
    end
    it "returns the version of the tag given and version is null" do
      payload = JSON.parse("{
            \"source\": {
                \"repo\": \"pivotal-cf/om\",
                \"tag\": \"4.4.1\"
            },
            \"version\": {
                \"version\": \"null\"
            }
        }")

      check = Check.new(payload)
      expect(check.pull_latest_versions).to eq "4.4.1"
    end
    it "returns latest version when latest tag is given" do
      allow(HttpClient).to receive(:get)
                              .and_return(JSON.parse(File.read(File.join(__dir__, "fixtures", "om-latest-releases-response.json"))))
      payload = JSON.parse("{
            \"source\": {
                \"repo\": \"pivotal-cf/om\",
                \"tag\": \"latest\"
            },
            \"version\": {
                \"version\": \"4.4.1\"
            }
        }")
      check = Check.new(payload)
      expect(check.pull_latest_versions).to eq "4.6.0"
    end
    it "returns last version when latest tag is given and version is null" do
      allow(HttpClient).to receive(:get)
                              .and_return(
                                  JSON.parse(File.read(File.join(__dir__, "fixtures", "om-latest-releases-response.json"))))
      payload = JSON.parse("{
            \"source\": {
                \"repo\": \"pivotal-cf/om\",
                \"tag\": \"latest\"
            },
            \"version\": {
                \"version\": null
            }
        }")
      check = Check.new(payload)
      expect(check.pull_latest_versions).to eq "4.6.0"
    end
  end
  context "#main" do
    it "prints versions to stdout" do
      payload = JSON.parse("{
            \"source\": {
                \"repo\": \"pivotal-cf/om\",
                \"tag\": \"latest\"
            },
            \"version\": {
                \"version\": null
            }
        }")
      check = Check.new(payload)
      allow(check).to receive(:pull_latest_versions).and_return "4.6.0"
      stdout = "[{\"version\":\"4.6.0\"}]\n" # why a newline?
      expect { check.main }.to output(stdout).to_stdout
    end
  end
end