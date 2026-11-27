module BahaiDate
  describe Occasion do
    subject(:occasion) do
      Occasion.new(type: :ayyam_i_ha,
        work_suspended: false,
        title: "Test title",
        short_title: "Test short title",
        title_html: "Test title html",
        short_title_html: "Test short title html             ")
    end

    it "can be created given an options hash" do
      expect(occasion).not_to be_nil
    end

    it "exposes a work_suspended? method" do
      expect(occasion.work_suspended?).to be false
    end
  end
end
