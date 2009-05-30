require 'csspool'
require 'seacrest/collectors'

module Seacrest
  module Collectors
    class HTMLCollector

      def initialize
        # ...
      end
      
      def handles? file
        File.extname(file) == ".html"
      end
    end
  end
end