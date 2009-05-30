require 'seacrest/collectors/css_collector'
require 'seacrest/collectors/html_collector'

module Seacrest
  module Collectors
    class << self
      def can_handle? file
        filetype = File.extname(file).gsub('.','').upcase
        filetype = filetype == "HTM" ? "HTML" : filetype

        self.const_defined? "#{filetype}Collector"
      end
    end
  end
end