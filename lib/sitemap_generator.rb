require 'find'
require 'fileutils'
require 'rubygems'
require 'nokogiri'

class SitemapGenerator
  attr_accessor :pages, :sitemap
  
  CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), "../config/config.yml"))
  
  # def initialize origin
  #   traverse origin
  #   build_sitemap @pages
  #   # puts @sitemap
  #   
  # end
  
  def traverse origin
    @pages = []
    Find.find origin do |path|
      path =~ /^#{origin}\/(.*)/
      unless File.directory? path
        @pages << $1 unless $1 == 'sitemap.xml'
      end
    end
    @pages
  end
  
  def determine_existing_pages
    @existing_pages = {}
    doc = Nokogiri::XML(open('sitemap.xml'))
    doc.xpath('/urlset/url/loc').each do |location|
      @existing_pages[location.text.to_sym] = true
    end
  end
  
  def build_sitemap
    # if File.exists?('sitemap.xml')
      doc = Nokogiri::XML(open('sitemap.xml'))
      doc.root = Nokogiri::XML::Node.new 'urlset', doc
    # else
    #   doc = Nokogiri::XML.new
    # end
    
    @pages.each do |page|
      # next if @existing_pages.include?(page.to_sym)
      url = Nokogiri::XML::Node.new('url', doc)
      page.each do |key, value|
        loc = Nokogiri::XML::Node.new('loc', doc)
        loc.content = key.to_s
        url << loc
      end
      doc.root << url
    end
  end
  
  # def something
  #   node = Nokogiri::XML::Node.new('existing_sitemap', @sitemap)
  #   builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do
  #     urlset(:xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9') {
  #       @new_pages.each do |page|
  #       url {
  #         loc page
  #         priority CONFIG['priority'] if CONFIG['priority']
  #         changefreq CONFIG['changefreq'] if CONFIG['changefreq']
  #       }
  #       end
  #     }
  #   end
  #   builder.to_xml
  # end
end