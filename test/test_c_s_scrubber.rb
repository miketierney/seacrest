require 'helper'

class TestCSScrubber < Test::Unit::TestCase
  def setup
    # ...
  end
  
  def test_asset_directory_exists
    assert (File.exist? "#{ASSET_DIR}/csscrubber.html"), "CSScrubber html file should exist."
  end
end