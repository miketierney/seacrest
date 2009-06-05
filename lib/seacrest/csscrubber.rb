require 'find'
require 'csspool'

module Seacrest
  class CSScrubber
    
    attr_accessor :css_files, :html_files

    def initialize root
      @root = root
      # @file = file
      @css_files = Array.new
      @html_files = Array.new
      
      traverse
    end
    
    def traverse
      Find.find @root do |path|
        path =~ /^#{@root}\/\w*.(\w*)/ # only need to capture the extension, since that's what we're checking against, and we're storing the whole path in the array
        unless File.directory? path
          if $1 == "css"
            @css_files << path
          elsif $1 == "html"
            @html_files << path
          end
        end
      end
    end
    
    def process_files
      for file in @css_files
        if Collectors.can_handle? @file
          css = Collectors::CSSCollector.new
          css.process file

          @all_selectors = css.all_selectors
          @selectors = css.unique_selectors
        end
      end
      
      for file in @html_files
        html = Collectors::HTMLCollector.new
        html.process file
      end
    end
    
  end
end