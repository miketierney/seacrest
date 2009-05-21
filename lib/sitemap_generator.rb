require 'find'
require 'fileutils'
require 'rubygems'
require 'nokogiri'

class SitemapGenerator
  # def initialze
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
end