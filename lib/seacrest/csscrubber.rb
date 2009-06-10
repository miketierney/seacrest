require 'find'
require 'csspool'

module Seacrest
  class CSScrubber

    attr_accessor :css_files, :html_files, :all_selectors, :unique_selectors, :unused_selectors, :dup_selectors, :files

    def initialize root
      @root = root

      # @file = file
      @css_files = []
      @html_files = []
      @files = {}

      @all_selectors = []
      @unique_selectors = {}
      @dup_selectors = {}

      traverse
    end

    def traverse
      Find.find @root do |path|
        path =~ /^#{@root}\/\w*.(\w*)/ # only need to capture the extension, since that's what we're checking against, and we're storing the whole path in the array
        next if File.extname(path).empty? # don't care about files without extensions

        ext = File.extname(path).gsub!('.','')

        unless File.directory? path
          if @files[ext].nil?
            @files[ext] = [path]
          else
            @files[ext] << path
          end
        end
      end
    end

    def process_files
      collection = Collectors.new @files
      collection.process_files
      
      @all_selectors = collection.all_selectors.flatten # Only want a one dimensional array.  None of this two dimensional nonsense.
      @unique_selectors = collection.unique_selectors
      @dup_selectors = collection.dup_selectors
      @unused_selectors = collection.unused_selectors
    end

  end
end