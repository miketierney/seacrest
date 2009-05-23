require 'find'
require 'fileutils'
require 'rubygems'
require 'nokogiri'

class SitemapGenerator
  attr_accessor :pages, :sitemap
  
  CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), "../config/config.yml"))
  
  def initialize origin
    traverse origin
    build_sitemap @pages
    puts @sitemap
    
  end
  
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
  
  def build_sitemap pages
    builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do
      urlset(:xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9') {
        pages.each do |page|
        url {
          loc page
          priority CONFIG['priority'] if CONFIG['priority']
          changefreq CONFIG['changefreq'] if CONFIG['changefreq']
        }
        end
      }
    end
    @sitemap = builder.to_xml
  end
end