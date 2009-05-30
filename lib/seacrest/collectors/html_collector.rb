require 'csspool'
require 'seacrest/collectors'

module Seacrest
  class HTMLCollector

    def initialize
      # ...
    end
    
    def handles? file
      File.extname(file) == ".html"
    end
  end
end