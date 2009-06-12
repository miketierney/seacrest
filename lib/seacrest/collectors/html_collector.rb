module Seacrest
  class HTMLCollector
    attr_accessor :selectors, :unused_selectors, :unique_selectors

    def initialize
      @selectors = [] # This array should be populated by the CSS Collector, since that's what we're checking against.
      @unused_selectors = []
      @pseudo_classes = []
    end

    def process file
      @doc = Nokogiri::HTML(open(file))
      @selectors.each do |selector|
        unless @unique_selectors[selector][:used] == true

          if selector =~ /\:(link|visited|hover|active)/
            selector_pieces = selector.split(":")
            target = selector_pieces.first
          else
            target = selector
          end

          if @doc.search(target).empty?
              @unused_selectors << selector
          else
            @unique_selectors[selector][:used] = true
          end
          
        end
      end
      
      @unused_selectors.uniq!
    end
    
  end
end
