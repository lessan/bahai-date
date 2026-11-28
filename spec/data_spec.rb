require_relative "../script/generate_data"

# docs/data is generated from the gem by script/generate_data.rb. This fails
# when the two drift apart: re-run the script and commit the result.
describe "the published dataset in docs/data" do
  it "matches what the gem computes" do
    expected = DataExport.files
    actual = Dir.glob("**/*", base: DataExport::OUT).select { |path| File.file?(File.join(DataExport::OUT, path)) }

    stale = expected.reject { |path, content| File.exist?(File.join(DataExport::OUT, path)) && File.read(File.join(DataExport::OUT, path)) == content }.keys
    extra = actual - expected.keys - DataExport::HAND_WRITTEN

    expect(stale + extra).to be_empty,
      "docs/data is out of date (#{(stale + extra).first(5).join(", ")}...). Run: bundle exec ruby script/generate_data.rb"
  end

  it "covers every supported year" do
    years = JSON.parse(File.read(File.join(DataExport::OUT, "years.json")))["years"]
    expect(years.map { |y| y["year"] }).to eq (1..BahaiDate::Year::MAX).to_a
  end
end
