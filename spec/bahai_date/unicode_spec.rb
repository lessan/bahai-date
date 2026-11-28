module BahaiDate
  # Names with diacritics are in Unicode NFC, the form web pages and most text
  # use, so an exact comparison with copied text matches.
  describe "names with diacritics" do
    it "are all in NFC" do
      strings = [Year, Month, Day, Weekday].flat_map { |k| k::TITLES_HTML } +
        OccasionFactory::OCCASIONS.values.flat_map { |o| [o[:title_html], o[:short_title_html]] }

      expect(strings.reject { |s| s == s.unicode_normalize(:nfc) }).to be_empty
    end
  end
end
