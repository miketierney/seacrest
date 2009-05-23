module CSS
  class StyleSheet < CSS::SAC::DocumentHandler
    def end_selector(selectors)
      @rules += @current_rules
      @current_rules = []
      @selector_index += 1
      reduce!
    end
    
    private
    # Remove duplicate rules
    def reduce!
      unique_rules = {}
      @rules.each do |rule|
        (unique_rules[rule.selector] ||= rule).properties += rule.properties
      end
      @rules = unique_rules.values
      self
    end
  end
end