require 'csspool'
require 'seacrest/collectors'
require 'seacrest/csscrubber/csscrubber_helper'

# List of things to tend to:
#
# Add the ability to ignore known frameworks (960.gs, blueprint.css, etc) or the ability to include these if they are ignored by default
#

module Seacrest
  class CSSHandler < CSS::SAC::DocumentHandler
    attr_accessor :selectors
    def initialize
      @selectors = Array.new
    end
    
    def start_selector(selectors)
      selectors.each{ |x| @selectors << x.to_css }
    end
  end

  class CSScrubber
    attr_accessor :selectors, :dup_selectors, :all_selectors
  
    def initialize(file)
      @content = File.read file
      @file = file
      @selectors = Hash.new
      @dup_selectors = Hash.new
      @all_selectors = Array.new
    end

    # TODO: Refactor this code.
    def what_ext? file
      begin
        if File.exist? file
          case File.extname(file)
          when ".css"
            "css"
          when ".html"
            "html"
          else
            "The file you supplied, #{file}, is not a valid HTML or CSS file.  Please enter another file."
          end
        else
          raise
        end
      rescue
        "The file you supplied, #{file}, is not a valid file; it either may not exist, or it may have been a directory."
      end
    end

    def parse_css
      parser = CSS::SAC::Parser.new(CSSHandler.new)
      css_content = parser.parse(File.read(@file))
      @all_selectors = css_content.selectors
      
      # TODO: REDUNDANT !!!  NEED TO REFACTOR !!!
      
      sac = CSS::SAC::Parser.new
      css = sac.parse(@content)
        
      css.rules.each do |rule|
        @selectors["#{rule.selector.to_css}"] = [(File.basename @file)]
      end
    end

    # def self.add_dups(selector)
    #   @all_selectors << selector
    # end
    # 
    def read_file file
      file_type = what_ext? file
      if file_type.css?
        @content = File.read file
        @file = file
        parse_css
      elsif file_type.html?
        @content = File.read file
        # parse_html
      else
        nil
      end
    end
  end
end