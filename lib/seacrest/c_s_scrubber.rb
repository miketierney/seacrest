require 'csspool'
# List of things to tend to:
#
# Add the ability to ignore known frameworks (960.gs, blueprint.css, etc) or the ability to include these if they are ignored by default
#

class String
  # just because I'm going to be typing this a *lot* otherwise... 
  def css?
    self == "css"
  end
  
  def html?
    self == "html"
  end
end

module Seacrest
  class CSScrubber
    attr_accessor :declarations, :dup_declarations
    
    def initialize
      @content = ""
      @file = ""
      @declarations = Hash.new
      @dup_declarations = Hash.new
    end

    # This code is awful.  I should probably be shot.  But first, give me a chance to refactor it.
    # TODO: Refactor this crappy code.
    def what_ext? file
      begin
        if File.exist? file
          case File.extname(file)
          when ".css"
            "css"
          when ".html"
            "html"
          else
            "The file you supplied, #{file}, is not a valid HTML or CSS file.  Please enter another file."
          end
        else
          raise
        end
      rescue
        "The file you supplied, #{file}, is not a valid file; it either may not exist, or it may have been a directory."
      end
    end

    def parse_css
      
    file = File.new('./test/assets/csscrubber.css')

    sac = CSS::SAC::Parser.new
    doc = sac.parse(file.read)
    doc.rules.each do |rule|
      puts rule.selector.to_css
      # puts rule.selector
      # rule.properties.each do |property|
      #   puts "  #{property[0]}: #{property[1]}#{' !important' unless property[2] == false};"
      # end
      # puts "}\n\n"
    end      
    #   line_number = 0
    #   line_numbers = Array.new
    #   line_array = Array.new
    #   
    #   @content.each_line do |line|
    #     line_numbers << line_number += 1
    #     line_array << line
    #   end
    #   
    #   big_line = line_array.join(" ") # to flatten the string
    #   big_line.gsub!(' ','')
    #   big_line.gsub!(/\n+/,'')
    # 
    #   new_array = big_line.split("}")
    #   new_array.each do |l|
    #     broken = l.split('{')
    #     puts broken.first
    #   end
    end

    def read_file file
      file_type = what_ext? file
      if file_type.css?
        @content = File.new file
        @file = file
        parse_css
      elsif file_type.html?
        @content = File.new file
        # parse_html
      else
        nil
      end
    end
  end
end