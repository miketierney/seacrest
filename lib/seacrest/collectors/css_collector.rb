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
          @unique_selectors[selector] = { :files => [filename], :used => false }
        else
          if @dup_selectors[selector] && !@dup_selectors[selector].include?(filename)
            @dup_selectors[selector] << filename
          else
            unless @unique_selectors[selector][:files].first == filename
              @dup_selectors[selector] = [@unique_selectors[selector][:files].first, filename]
            else
              @dup_selectors[selector] = @unique_selectors[selector][:files]
            end
          end
        end
        
      end
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
