require 'csspool'
require 'seacrest/collectors'

module Seacrest
  class CSSCollector
    #
    # I'd love for this to just be class CSS, but because of the CSS::SAC usage, I run into naming issues, so for now I've got this named differently in order to prevent that.
    #
    attr_accessor :unique_selectors, :dup_selectors, :all_selectors

    def initialize
      @all_selectors = []
      @unique_selectors = {}
      @dup_selectors = {}
    end

    # TODO: Refactor this for easier reading and more efficient code handling
    def process file
      filename = File.basename(file)

      parser = CSS::SAC::Parser.new(CSSHandler.new)
      css_content = parser.parse(File.read(file))
      @all_selectors = css_content.selectors

      @all_selectors.each do |selector|
        if ! @unique_selectors[selector]
          # @unique_selectors[selector] = [filename, find_line_number(file, selector)]
          @unique_selectors[selector] = [filename]
        else
          if ! @dup_selectors[selector]
            # first time out, we want to grab the one from the "unique" selectors list and add it to the duplicated selectors list so that we have ALL occurrences of the selector in the dup list.
            @dup_selectors[selector] = [@unique_selectors[selector],[filename]]
          else
            # once there's a key in the hash, just add to that key.
            @dup_selectors[selector] += [[filename]] # this seems silly to me ...
          end
        end
      end
    end
    # HOLY CRAP THAT'S A LOT OF "END"s!!!

    def handles? file
      File.extname(file) == ".css" # if it's that extension, then it handles it.  Otherwise, it doesn't.
    end

  end

  class CSSHandler < CSS::SAC::DocumentHandler

    attr_accessor :selectors

    def initialize
      @selectors = []
    end

    def start_selector(selectors)
      selectors.each{ |x| @selectors << x.to_css }
    end
  end
end
