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

  it "gives the Eastern reconstruction only for years before 172, as data" do
    early = JSON.parse(File.read(File.join(DataExport::OUT, "years", "18.json")))
    late = JSON.parse(File.read(File.join(DataExport::OUT, "years", "183.json")))

    expect(early["eastern_reconstruction"]).to include("nawruz" => "1861-03-21", "uncertain" => true)
    expect(late).not_to have_key("eastern_reconstruction")
  end

  it "lists no Holy Day before its event" do
    first = JSON.parse(File.read(File.join(DataExport::OUT, "years", "1.json")))
    expect(first["holy_days"].map { |h| h["id"] }).to contain_exactly("nawruz", "declaration_bab", "birth_bab", "birth_bahaullah")
    expect(first["holy_days"].find { |h| h["id"] == "declaration_bab" }["status"]).to eq "event"
  end
end
