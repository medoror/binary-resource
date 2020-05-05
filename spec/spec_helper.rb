RSpec.configure do |config|
  original_stdin = $stdin
  config.before(:all) do
    $stdin = File.open(File::NULL, "w")
  end
  config.after(:all) do
    $stdin = original_stdin
  end
end
