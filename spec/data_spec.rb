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
    expect(first["holy_days"].find { |h| h["id"] == "declaration_bab" }["status"]).to eq "event-year"
  end

  it "has every year file in the shape its JSON Schema describes" do
    schema = JSON.parse(File.read(File.join(DataExport::OUT, "schema", "year.schema.json")))
    allowed = schema["properties"].keys
    holy_allowed = schema["properties"]["holy_days"]["items"]["properties"].keys

    wrong = Dir.glob(File.join(DataExport::OUT, "years", "*.json")).filter_map do |path|
      year = JSON.parse(File.read(path))
      problems = (schema["required"] - year.keys).map { |k| "missing #{k}" } + (year.keys - allowed).map { |k| "unexpected #{k}" }
      year["holy_days"].each { |h| problems += (h.keys - holy_allowed).map { |k| "unexpected holy day #{k}" } }
      [File.basename(path), problems] unless problems.empty?
    end

    expect(wrong).to be_empty, wrong.first(3).inspect
  end

  it "cites only sources listed on the sources page in events.json and facts.json" do
    ids = File.read(File.expand_path("../docs/sources.md", __dir__)).scan(/<a id="([^"]+)"><\/a>/).flatten
    events = JSON.parse(File.read(File.join(DataExport::OUT, "events.json")))["events"]
    cited = events.flat_map { |e| e["gregorian_dates"].flat_map { |g| g["sources"] } }
    facts = JSON.parse(File.read(File.join(DataExport::OUT, "facts.json")))
    cited += facts["holy_days"].flat_map { |h| h.dig("commemoration", "sources") || [] }

    expect(cited.uniq - ids).to be_empty
  end

  it "writes names in Unicode NFC" do
    %w[years.csv holy-days.csv months.csv facts.json years/183.json].each do |file|
      text = File.read(File.join(DataExport::OUT, file))
      expect(text).to eq(text.unicode_normalize(:nfc)), file
    end
  end
end
