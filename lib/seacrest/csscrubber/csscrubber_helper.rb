# For monkey-patching, extending, adding on to, and basically mangling up other code that's not mine in the first place.

class String
  # just because I'm going to be typing this a *lot* otherwise... 
  def css?
    self == "css"
  end
  
  def html?
    self == "html"
  end
end