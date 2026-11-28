require "tmpdir"
require_relative "../script/build_site"

# Builds the GitHub Pages site and checks it the way a reader or an agent would
# use it: every internal link and #anchor resolves, and each page is complete.
describe "the built site" do
  before(:all) do
    @dir = Dir.mktmpdir("bahai-date-site")
    Site.build(@dir)
    @pages = Dir.glob("**/*.html", base: @dir).to_h { |p| [p, File.read(File.join(@dir, p))] }
  end

  after(:all) { FileUtils.rm_rf(@dir) }

  def ids(html)
    html.scan(/\sid="([^"]+)"/).flatten
  end

  it "has a page for every Markdown file, and the Markdown itself beside it" do
    %w[index rules history years sources data/index].each { |page| expect(@pages).to have_key("#{page}.html") }
    %w[index.md rules.md history.md sources.md data/README.md llms.txt llms-full.txt sitemap.xml].each do |file|
      expect(File).to exist(File.join(@dir, file)), file
    end
  end

  it "resolves every internal link and anchor" do
    broken = @pages.flat_map do |path, html|
      html.scan(/href="([^"]+)"/).flatten.reject { |h| h.start_with?("http", "mailto:") }.filter_map do |href|
        target, anchor = href.split("#", 2)
        file = target.empty? ? path : File.expand_path(target, File.dirname(File.join(@dir, path))).delete_prefix("#{@dir}/")
        file = File.join(file, "index.html") if File.directory?(File.join(@dir, file))
        if !File.exist?(File.join(@dir, file))
          "#{path}: #{href} (no such file)"
        elsif anchor && file.end_with?(".html") && !ids(File.read(File.join(@dir, file))).include?(CGI.unescape(anchor))
          "#{path}: #{href} (no such anchor)"
        end
      end
    end

    expect(broken).to be_empty, broken.first(10).join("\n")
  end

  it "fills in every page's title, description and canonical link" do
    @pages.each do |path, html|
      next if path.start_with?("data/years/")

      expect(html).not_to include("{{"), path
      expect(html[/<meta name="description" content="([^"]*)"/, 1].to_s.length).to be > 40, path
      expect(html).to include('<link rel="canonical" href="https://lessan.github.io/bahai-date/'), path
    end
  end

  it "renders the History page's opening paragraph whole" do
    expect(@pages["history.html"]).to include("The <a href=\"rules.html\">rules</a> describe the calendar from 2015.")
  end

  it "marks the current page in the navigation" do
    expect(@pages["history.html"]).to include('<a href="history.html" aria-current="page">History</a>')
  end
end
