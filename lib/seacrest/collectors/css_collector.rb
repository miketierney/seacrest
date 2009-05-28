require 'csspool'
require 'seacrest/collectors'

module Seacrest
  module Collectors
    class CSSCollector < CSS::SAC::DocumentHandler

      attr_accessor :selectors

      def initialize
        @selectors = Array.new
      end
  
      def start_selector(selectors)
        selectors.each{ |x| @selectors << x.to_css }
      end
    end
  end
end