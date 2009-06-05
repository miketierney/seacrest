require 'csspool'

# List of things to tend to:
#
# Add the ability to ignore known frameworks (960.gs, blueprint.css, etc) or the ability to include these if they are ignored by default
#
module Seacrest
  class CSScrubber

    def initialize(file)
      @file = file
      @css_files = Array.new
      @html_files = Array.new
    end
    
    def process_file
      raise "The file you supplied, #{File.basename(@file)}, is not a valid file; it either may not exist, or it may have been a directory." unless File.exist?(@file)

      if Collectors.can_handle? @file
        css = Collectors::CSSCollector.new
        css.process @file

        @all_selectors = css.all_selectors
        @selectors = css.unique_selectors
        
        html = Collectors::HTMLCollector.new
        html.process @file
      end
    end

  end
end