require 'csspool'
require 'seacrest/collectors'

module Seacrest
  class HTMLCollector
    attr_accessor :selectors, :unused_selectors

    def initialize
      @selectors = Array.new # This array should be populated by the CSS Collector, since that's what we're checking against.
      @unused_selectors = Array.new
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

  end
end