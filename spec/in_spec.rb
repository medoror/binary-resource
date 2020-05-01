require_relative '../src/in'
require 'fakefs/safe'

describe "in" do
  payload = JSON.parse("{
            \"source\": {
                \"repo\": \"pivotal-cf/om\",
                \"tag\": \"4.6.0\"
            },
            \"version\": {
                \"version\": \"4.6.0\"
            }
        }")
  in_script = In.new(payload)
  context "initialize" do
    it "pulls version from stdin" do
      expect(in_script.version).to eq "4.6.0"
    end
  end
  context "get_download_link" do
    it "get download link given a release" do
      expect(in_script.get_download_link(
          JSON.parse(File.read(File.join(__dir__, "fixtures", "om-single-tag-release.json")
      )))).to eq "https://github.com/pivotal-cf/om/releases/download/4.6.0/om-linux-4.6.0.tar.gz"
    end
    it "raises error if download link could not be retrieved" do
      expect{ in_script.get_download_link(nil) }
          .to raise_error "Download Link could not be retrieved"
      expect{ in_script.get_download_link(JSON.parse(File.read(
          File.join(__dir__, "fixtures", "om-single-tag-release-no-assets.json")))) }
          .to raise_error "Download Link could not be retrieved"
      expect{ in_script.get_download_link(JSON.parse(File.read(
          File.join(__dir__, "fixtures", "om-single-tag-release-no-tgz.json")))) }
          .to raise_error "Download Link could not be retrieved"
    end
  end
  # context "#download_binary" do
  #   it "downloads binary according to given version" do
  #     # expect(Net::HTTP).to receive(:get_response)
  #     #                          .with("").and_return(nil)
  #     # in_script.download_version
  #
  #   end
  #
  #   it "raises error if download fails" do
  #
  #   end
  # end

  context "#create_dest_dir" do
    it "creates given destination directory" do
      FakeFS do
        expect(FileUtils).to receive(:mkdir_p).with("tmp").once
        in_script.create_dest_dir("tmp")
      end
    end
  end
end