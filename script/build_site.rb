#!/usr/bin/env ruby
# Builds the GitHub Pages site into _site/ from docs/:
#
#   bundle exec ruby script/build_site.rb
#   ruby -run -e httpd _site -p 8000     # then open http://localhost:8000/
#
# Markdown pages are rendered into site/layout.html; everything else in docs/
# (the dataset, llms.txt, scripts, styles) is copied as it is. Links between
# Markdown files (foo.md, data/README.md) become links between pages, so the
# same files read correctly on GitHub and on the site.

require "fileutils"
require "kramdown"
require "kramdown-parser-gfm"

module Site
  ROOT = File.expand_path("..", __dir__)
  DOCS = File.join(ROOT, "docs")
  OUT = File.join(ROOT, "_site")
  LAYOUT = File.read(File.join(DOCS, "site", "layout.html"))

  def self.page_path(md)
    (md == "index.md") ? "index.html" : md.sub(/README\.md\z/, "index.html").sub(/\.md\z/, ".html")
  end

  def self.title(markdown)
    markdown[/^# (.+)$/, 1] || "Bahá’í dates"
  end

  # Relative path from a page back to the site root, for links in the layout.
  def self.root_for(path)
    "../" * path.count("/")
  end

  def self.render(md)
    markdown = File.read(File.join(DOCS, md))
    html = Kramdown::Document.new(markdown, input: "GFM", hard_wrap: false, auto_ids: true).to_html
    html = html.gsub(/href="(?!https?:|#|mailto:)([^"]*?)(README)?\.md(#[^"]*)?"/) do
      target, readme, anchor = $1, $2, $3
      "href=\"#{target}#{"index" if readme}.html#{anchor}\""
    end
    path = page_path(md)
    LAYOUT
      .gsub("{{title}}", title(markdown))
      .gsub("{{root}}", root_for(path))
      .gsub("{{content}}", html)
  end

  def self.build
    FileUtils.rm_rf(OUT)
    FileUtils.mkdir_p(OUT)
    Dir.glob("**/*", base: DOCS).sort.each do |rel|
      src = File.join(DOCS, rel)
      next if File.directory?(src) || rel == "site/layout.html"

      if rel.end_with?(".md")
        dest = File.join(OUT, page_path(rel))
        FileUtils.mkdir_p(File.dirname(dest))
        File.write(dest, render(rel))
      else
        dest = File.join(OUT, rel)
        FileUtils.mkdir_p(File.dirname(dest))
        FileUtils.cp(src, dest)
      end
    end
    File.write(File.join(OUT, ".nojekyll"), "")
  end
end

Site.build if $PROGRAM_NAME == __FILE__
