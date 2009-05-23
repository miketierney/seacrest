require 'find'
require 'fileutils'
require 'rubygems'
require 'nokogiri'

class SitemapGenerator
  attr_accessor :sitemap
  
  CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), "../config/config.yml"))
  
  def initialize origin
    traverse origin
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
end