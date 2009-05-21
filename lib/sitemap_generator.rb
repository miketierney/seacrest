require 'find'
require 'fileutils'

class SitemapGenerator
  # def initialze
  # end
  
  def traverse origin
    @pages = []
    Find.find origin do |path|
      path =~ /^#{origin}\/(.*)/
      unless File.directory? path
        @pages << $1
      end
    end
    @pages
  end
end