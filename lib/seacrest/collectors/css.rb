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
    
    class CSS
      
      attr_accessor :unique_selectors, :dup_selectors
      
      def parse file
        parser = CSS::SAC::Parser.new(CSSHandler.new)
        css_content = parser.parse(File.read(file))
        all_selectors = css_content.selectors
      
        # TODO: REDUNDANT !!!  NEED TO REFACTOR !!!
      
        sac = CSS::SAC::Parser.new
        css = sac.parse(@content)
        
        css.rules.each do |rule|
          @selectors["#{rule.selector.to_css}"] = [(File.basename file)]
        end
      end
    end
  end
end