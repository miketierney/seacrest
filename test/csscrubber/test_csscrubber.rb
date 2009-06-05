require 'helper'

class TestCSScrubber < Test::Unit::TestCase
  def setup
    @css = "#{ASSET_DIR}/csscrubber.css"
    @html = "#{ASSET_DIR}/csscrubber.html"
    @scrubber = Seacrest::CSScrubber.new ASSET_DIR
  end

  def test_asset_directory_exists # 'cause I created it, and I want to make sure that this actually works.  Will fail if the stuff doesn't exist.
    assert File.exist?(@html), "CSScrubber html file should exist."
  end
  
  # def test_should_warn_if_file_doesnt_exist
  #   new_scrubber = CSScrubber.new "massive_fail.html"
  # 
  #   assert_raise RuntimeError do
  #     new_scrubber.process_file
  #   end
  # end
  
  def test_stores_html_files_recursively_through_traverse
    expected = [
      "#{ASSET_DIR}/index.html",
      "#{ASSET_DIR}/csscrubber.html"
    ]
    assert_equal expected, @scrubber.html_files
  end
  
  def test_stores_css_files_recursively_through_traverse
    expected = [
      "#{ASSET_DIR}/csscrubber.css"
    ]
    assert_equal expected, @scrubber.css_files
  end
  
end