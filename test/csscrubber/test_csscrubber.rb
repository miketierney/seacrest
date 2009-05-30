require 'helper'

class TestCSScrubber < Test::Unit::TestCase
  def setup
    @css = "#{ASSET_DIR}/csscrubber.css"
    @html = "#{ASSET_DIR}/csscrubber.html"
    @scrubber = Seacrest::CSScrubber.new @css
  end

  def test_asset_directory_exists # 'cause I created it, and I want to make sure that this actually works.  Will fail if the stuff doesn't exist.
    assert File.exist?(@html), "CSScrubber html file should exist."
  end

  def test_should_warn_if_file_doesnt_exist
    new_scrubber = CSScrubber.new "massive_fail.html"

    assert_raise RuntimeError do
      new_scrubber.process_file
    end
  end
end