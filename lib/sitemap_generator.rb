require 'find'
require 'fileutils'
require 'nokogiri'

class SitemapGenerator
  attr_accessor :pages, :sitemap, :existing_pages

  CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), "../config/config.yml")) || {}

  def initialize origin
    @pages = []
    @existing_pages = {}
    @origin = File.expand_path(origin)
    traverse
    build_sitemap
  end

  def traverse
    Find.find @origin do |path|
      if path =~ /^#{@origin}\/(.+)/
      unless File.directory?(path) && File.exists?(path)
        @pages << $1 unless $1 == 'sitemap.xml'
      end
      end
    end
  end

  def build_sitemap
    if File.exists?(File.join(@origin, 'sitemap.xml'))
      @sitemap = Nokogiri::XML(open(File.join(@origin, 'sitemap.xml')))
      store_existing_pages
    else
      @sitemap = Nokogiri::XML::Document.new
      @sitemap.root = Nokogiri::XML::Node.new('urlset', @sitemap)
      @sitemap.root.default_namespace = 'http://www.sitemaps.org/schemas/sitemap/0.9'
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
    @sitemap.css('urlset > url').each do |url|
      href = url.at('loc').text
      @existing_pages[href] = {}
      url.children.each do |child|
        next if ['loc', 'text'].include? child.name
        @existing_pages[href][child.name.to_sym] = child.text
      end
    end
  end

  def add_namespaces
    @sitemap.root.add_namespace('xsi', 'http://www.w3.org/2001/XMLSchema-instance')
    @sitemap.root.add_namespace('xsi:schemaLocation', 'http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd')
  end

  def write_sitemap
    expanded = File.expand_path(File.join(@origin, 'sitemap.xml'))
    file = File.open(expanded, 'w')
    @sitemap.write_xml_to file, :indent => 5
    file.rewind
  end
end