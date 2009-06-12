require 'csspool'
require 'seacrest/collectors'

module Seacrest
  class CSSCollector
    #
    # I'd love for this to just be class CSS, but because of the CSS::SAC usage, I run into naming issues, so for now I've got this named differently in order to prevent that.
    #
    attr_accessor :unique_selectors, :dup_selectors, :all_selectors

    def initialize
      @all_selectors = Array.new
      @unique_selectors = Hash.new
      @dup_selectors = Hash.new
    end

    # TODO: Refactor this for easier reading and more efficient code handling
    def process file
      filename = File.basename(file)

      parser = CSS::SAC::Parser.new(CSSHandler.new)
      css_content = parser.parse(File.read(file))
      @all_selectors = css_content.selectors

      @all_selectors.each do |selector|
        if @unique_selectors[selector].nil?
          # @unique_selectors[selector] = [filename, find_line_number(file, selector)]
          @unique_selectors[selector] = { :files => [filename], :used => false }
        else
          if @dup_selectors[selector].nil?
            # first time out, we want to grab the one from the "unique" selectors list and add it to the duplicated selectors list so that we have ALL occurrences of the selector in the dup list.
            @dup_selectors[selector] = @unique_selectors[selector][:files]
          else
            # once there's a key in the hash, just add to that key.
            unless @dup_selectors[selector].include? filename
              @dup_selectors[selector] << filename
            end
          end
        end
      end
    end
    # HOLY CRAP THAT'S A LOT OF "END"s!!!
  end

  class CSSHandler < CSS::SAC::DocumentHandler

    attr_accessor :selectors

    def initialize
      @selectors = Array.new
    end

    def start_selector(selectors)
      selectors.each{ |x| @selectors << x.to_css }
    end
  end
end