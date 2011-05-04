require 'csspool'

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

      doc = CSSHandler.new
      parser = CSSPool::SAC::Parser.new(doc)
      parser.parse(File.read(file))

      @all_selectors = doc.selectors

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

  class CSSHandler < CSSPool::CSS::DocumentHandler

    attr_accessor :selectors
    # defaults
    attr_accessor :start_documents, :end_documents
    attr_accessor :charsets, :import_styles, :comment, :start_selectors
    attr_accessor :end_selectors, :properties

    def initialize
      @selectors = []

      @start_documents = []
      @end_documents = []
      @charsets = []
      @import_styles = []
      @comments = []
      @start_selectors = []
      @end_selectors = []
      @properties = []
    end

    def property name, expression, important
      @properties << [name, expression]
    end

    def start_document
      @start_documents << true
    end

    def end_document
      @end_documents << true
    end

    def charset name, location
      @charsets << [name, location]
    end

    def import_style media_list, uri, default_ns = nil, location = {}
      @import_styles << [media_lists, uri, default_ns, location]
    end

    def namespace_declarations prefix, uri, location
      @import_styles << [prefix, uri, location]
    end

    def comment string
      @comments << string
    end

    def start_selector selectors
      @start_selectors << selectors
      selectors.each{ |x| @selectors << x.to_css }
    end

    def end_selector selectors
      @end_selectors << selectors
    end
  end
end
