require 'csspool'
require 'seacrest/collectors'

module Seacrest
  module Collectors
    class CSSHandler < CSS::SAC::DocumentHandler

      attr_accessor :selectors

      def initialize
        @selectors = Array.new
      end
  
      def start_selector(selectors)
        selectors.each{ |x| @selectors << x.to_css }
      end
    end
    
    class CSSCollector
      
      attr_accessor :unique_selectors, :dup_selectors, :all_selectors
      
      def initialize
        @all_selectors = Array.new
        @unique_selectors = Hash.new
      end
      
      def parse file
        parser = CSS::SAC::Parser.new(CSSHandler.new)
        css_content = parser.parse(File.read(file))
        @all_selectors = css_content.selectors

        @all_selectors.each do |selector|
          next if !@unique_selectors[selector].nil?
          # @unique_selectors[selector] = [File.basename(file), find_line_number(file, selector)]
          @unique_selectors[selector] = [File.basename(file)]
        end
      end
      
      def find_line_number file, selector
        
      end
    end
  end
end