require 'find'
require 'csspool'

module Seacrest
  class CSScrubber
    
    attr_accessor :css_files, :html_files, :all_selectors, :unique_selectors, :unused_selectors, :dup_selectors, :files

    def initialize root
      @root = root
      @collectors = Collectors.new
      
      # @file = file
      @css_files = Array.new
      @html_files = Array.new
      @files = Hash.new
      
      @all_selectors = Array.new
      @unique_selectors = Hash.new
      @dup_selectors = Hash.new
      
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
            @files[ext] += [path]
          end
        end
      end
    end

    def process_files
      
      # for file in @css_files
        # if @collectors.can_handle? file
          # css = Collectors::CSSCollector.new
          # css.process file
          
          # @all_selectors = css.all_selectors
          # @unique_selectors = css.unique_selectors
          # @dup_selectors = css.dup_selectors

          # @all_selectors << css.all_selectors
          
          # for selector in css.unique_selectors
          #   if @unique_selectors[selector].nil?
          #     @unique_selectors[selector] = [filename]
          #   end
        # end
      # end
      # 
      # for file in @html_files
      #   if @collectors.can_handle? file
      #     html = Collectors::HTMLCollector.new
      #     html.process file
      #   end
      # end
    end
    
  end
end