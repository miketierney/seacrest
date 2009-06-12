require 'seacrest/collectors/css_collector'
require 'seacrest/collectors/html_collector'

module Seacrest
  class Collectors

    attr_accessor :unique_selectors, :dup_selectors, :unused_selectors, :all_selectors

    def initialize file_hash
      @files = file_hash

      @all_selectors    = []
      @unique_selectors = {}
      @dup_selectors    = {}
      @unused_selectors = []
    end

    def can_handle? file
      filetype = File.extname(file).gsub('.','').upcase
      filetype = filetype == "HTM" ? "HTML" : filetype

      Seacrest.const_defined? "#{filetype}Collector"
    end

    def process_files
      @files['html'] += @files['htm'] # because .htm files should be handled the same as .html, even though they're old and stupid.
      @files.delete('htm') # then kill it because we don't want it causing us any trouble. Or slow us down.

      collection = @files.sort # we need to guarantee that CSS files will be processed before HTML files.  This might get sticky, but should hold up reasonably well... for now.
      
      collection.each do |files|
        if can_handle? files.last.first # should be the first file in the array of files.
          ext = files.first

          collector = eval("#{ext.upcase}Collector").new
          # @processed["#{ext.downcase}"] = []

          files.last.each do |file|
            if ext.downcase == 'css'
              collector.process(file)
              
              @unique_selectors.merge!(collector.unique_selectors)
              @dup_selectors.merge!(collector.dup_selectors)
              @all_selectors << collector.all_selectors

            elsif ext.downcase == 'html'
              collector.selectors = @all_selectors.flatten
              collector.unique_selectors = @unique_selectors

              collector.process(file)
              @unused_selectors << collector.unused_selectors
              
            end
          end
        end
      end
      
      @unused_selectors.flatten!

      @unused_selectors.each do |selector|
        if @unique_selectors[selector][:state] == true
          @unused_selectors.delete(selector)
        end
      end
      
    end

  end
end
