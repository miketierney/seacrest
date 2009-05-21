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
    def initialize
      # ...
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

    def read_file file
      file_type = what_ext? file
      if file_type.css?
        content = File.open file
      elsif file_type.html?
        content = File.open file
      else
        nil
      end
    end
  end
end