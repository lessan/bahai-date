module BahaiDate
  class Occasion
    attr_reader :type,
      :work_suspended,
      :title,
      :short_title,
      :title_html,
      :short_title_html
    alias_method :work_suspended?, :work_suspended

    def initialize(opts = {})
      @type = opts[:type]
      @work_suspended = opts[:work_suspended]
      @title = opts[:title]
      @short_title = opts[:short_title]
      @title_html = opts[:title_html]
      @short_title_html = opts[:short_title_html]
    end
  end
end
