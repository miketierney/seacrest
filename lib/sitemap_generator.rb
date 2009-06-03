require 'find'
require 'fileutils'
require 'nokogiri'

class SitemapGenerator
  attr_accessor :pages, :sitemap, :existing_pages

  CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), "../config/config.yml"))

  def initialize origin
    @origin = origin
    traverse
    build_sitemap
  end

  def traverse
    @pages = []
    Find.find @origin do |path|
      path =~ /^#{@origin}\/(.*)/
      unless File.directory? path
        @pages << $1 unless $1 == 'sitemap.xml'
      end
    end
  end

  def store_existing_pages
    @existing_pages = {}
    @sitemap.xpath('/urlset/url/loc').each do |loc|
      @existing_pages[loc.text] = {}
      @sitemap.xpath('/urlset/url/*[position()>1]').each do |node|
        @existing_pages[loc.text][node.name.to_sym] = node.text
      end
    end
  end

  def build_sitemap
    if File.exists?(File.join(@origin, 'sitemap.xml'))
      @sitemap = Nokogiri::XML(open(File.join(@origin, 'sitemap.xml')))
      store_existing_pages
    else
      @sitemap = Nokogiri::XML.new
      @sitemap.root = Nokogiri::XML::Node.new('urlset', @sitemap)
    end

    @pages.each do |page|
      next if @existing_pages.include?(page)
      url = Nokogiri::XML::Node.new('url', @sitemap)
      page.each do |key, value|
        loc = Nokogiri::XML::Node.new('loc', @sitemap)
        loc.content = key.to_s
        url << loc
      end
      @sitemap.root << url
    end
  end
end