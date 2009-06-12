require 'csspool'
require 'seacrest/collectors'

module Seacrest
  class HTMLCollector
    attr_accessor :selectors, :unused_selectors, :unique_selectors

    def initialize
      @selectors = [] # This array should be populated by the CSS Collector, since that's what we're checking against.
      @unused_selectors = []
      # @unique_selectors = {}
    end

    def process file
      doc = Nokogiri::HTML(open(file))
      @selectors.each do |selector|
        if doc.search(selector).empty?
          next if @unused_selectors.include? selector
          next if @unique_selectors[selector][:state] == true
          @unused_selectors << selector
        else
          @unique_selectors[selector][:state] = true
        end
      end
    end

  end
end