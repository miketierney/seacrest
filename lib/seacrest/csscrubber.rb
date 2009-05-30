require 'csspool'

# List of things to tend to:
#
# Add the ability to ignore known frameworks (960.gs, blueprint.css, etc) or the ability to include these if they are ignored by default
#
module Seacrest
  class CSScrubber

    def initialize(file)
      @file = file
    end

    def process_file
      # TODO: feels like I'm using the rescue statement as a flow-control mechanism... don't like this.
      # begin
      raise "The file you supplied, #{File.basename(@file)}, is not a valid file; it either may not exist, or it may have been a directory." unless File.exist?(@file)

      if Collectors.can_handle? @file

        css = Collectors::CSSCollector.new
        css.process @file

        @all_selectors = css.all_selectors
        @selectors = css.unique_selectors
      end
    end

  end
end