require 'csspool'
require 'seacrest/collectors'

module Seacrest
  class HTMLCollector
    attr_accessor :selectors, :unused_selectors

    def initialize
      @selectors = [] # This array should be populated by the CSS Collector, since that's what we're checking against.
      @unused_selectors = []
    end

    def process file
      doc = Nokogiri::HTML(open(file))

      @selectors.each do |selector|
        if doc.search(selector).empty?
          next if @unused_selectors.include? selector
          @unused_selectors << selector
        end
      end
    end

    def handles? file
      File.extname(file) == ".html"
    end
  end
end
