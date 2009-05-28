require 'seacrest/collectors'

# $: << File.dirname(__FILE__)

# require 'seacrest'
# require 'seacrest/csscrubber'

# module CSS
#   # include Seacrest::CSScrubber
#   class StyleSheet < CSS::SAC::DocumentHandler
#     def end_selector(selectors)
#       @rules += @current_rules
#       @current_rules = []
#       @selector_index += 1
#       reduce!
#     end
#     
#     private
#     # Remove duplicate rules
#     def reduce!
#       unique_rules = {}
#       @rules.each do |rule|
#         (unique_rules[rule.selector] ||= rule).properties += rule.properties
#         # unless rule.selector.nil?
#         #   Seacrest::CSScrubber.add_dups(rule.selector.to_css)
#         # end
#       end
#       @rules = unique_rules.values
#       self
#     end
#   end
# end

class String
  # just because I'm going to be typing this a *lot* otherwise... 
  def css?
    self == "css"
  end
  
  def html?
    self == "html"
  end
end

# class DH < CSS::SAC::DocumentHandler
#   def start_selector(selectors)
#     selectors.map { |x| x.to_css }
#   end
# end
