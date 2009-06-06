require 'find'
require 'fileutils'
require 'nokogiri'

class SitemapGenerator
  attr_accessor :pages, :sitemap, :existing_pages

  CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), "../config/config.yml")) || {}

  def initialize origin
    @pages = []
    @existing_pages = {}
    @origin = origin
    traverse
    build_sitemap
  end

  def traverse
    Find.find @origin do |path|
      path =~ /^#{@origin}\/(.*)/
      unless File.directory? path
        @pages << $1 unless $1 == 'sitemap.xml'
      end
    end
  end

  def build_sitemap
    if File.exists?(File.join(@origin, 'sitemap.xml'))
      @sitemap = Nokogiri::XML(open(File.join(@origin, 'sitemap.xml')))
      store_existing_pages
    else
      @sitemap = Nokogiri::XML::Document.new
      @sitemap.default_namespace = 'http://www.sitemaps.org/schemas/sitemap/0.9'
      @sitemap.root = Nokogiri::XML::Node.new('urlset', @sitemap)
    end

    @pages.each do |page|
      next if @existing_pages.include?(page)
      url = Nokogiri::XML::Node.new('url', @sitemap)
      page.each do |key, value|
        loc = Nokogiri::XML::Node.new('loc', @sitemap)
        loc.content = key.to_s
        url << loc
        if CONFIG['priority']
          priority = Nokogiri::XML::Node.new('priority', @sitemap)
          priority.content = CONFIG['priority']
          url << priority
        end
        if CONFIG['changefreq']
          changefreq = Nokogiri::XML::Node.new('changefreq', @sitemap)
          changefreq.content = CONFIG['changefreq']
          url << changefreq
        end
      end
      @sitemap.root << url
      add_namespaces if CONFIG['validate']
      write_sitemap
    end
  end

  def store_existing_pages
    @sitemap.css('urlset > url > loc').each do |loc|
      @existing_pages[loc.text] = {}
      @sitemap.xpath('/urlset/url/*[position()>1]').each do |node|
        @existing_pages[loc.text][node.name.to_sym] = node.text
      end
    end
  end

  def add_namespaces
    @sitemap.root.add_namespace('xsi', 'http://www.w3.org/2001/XMLSchema-instance')
    @sitemap.root.add_namespace('xsi:schemaLocation', 'http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd')
  end

  def write_sitemap
    file = File.open(File.join(@origin, 'sitemap.xml'), 'w')
    @sitemap.write_xml_to file, :indent => 5
    file.rewind
  end
end