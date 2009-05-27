require 'csspool'
require 'seacrest/csscrubber/helper'

# List of things to tend to:
#
# Add the ability to ignore known frameworks (960.gs, blueprint.css, etc) or the ability to include these if they are ignored by default
#

class String
  # just because I'm going to be typing this a *lot* otherwise... 
  def css?
    self == "css"
  end
  
  def html?
    self == "html"
  end
end

module Seacrest
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