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

  def test_stores_files_recursively_through_traverse
    expected = {
      'html' => [
        "#{ASSET_DIR}/index.html",
        "#{ASSET_DIR}/csscrubber.html"
      ],
      'htm' => [
        "#{ASSET_DIR}/old_timer.htm"
      ],
      'css' => [
        "#{ASSET_DIR}/stylesheets/globals.css",
        "#{ASSET_DIR}/csscrubber.css"
      ]}
    
    assert_equal expected, @scrubber.files
  end
  
  # def test_stores_css_files_recursively_through_traverse
  #   expected = [
  #     "#{ASSET_DIR}/stylesheets/globals.css",
  #     "#{ASSET_DIR}/csscrubber.css"
  #   ]
  #   assert_equal expected, @scrubber.css_files
  # end
  
  def test_stores_unique_selectors
    @scrubber.process_files
    
    actual = @scrubber.unique_selectors
    expected = ['something']
    assert_equal expected, actual
  end
  
  def test_stores_all_selectors
    @scrubber.process_files
    
    actual = @scrubber.all_selectors
    expected = {"selector" => ['filename']}
    assert_equal expected, actual
  end
  
  def test_stores_unused_selectors
    @scrubber.process_files
    
    actual = @scrubber.unused_selectors
    expected = {"selector" => ['filename']}
    assert_equal expected, actual
  end
  
  def test_stores_duplicate_selectors
    @scrubber.process_files
    
    actual = @scrubber.duplicate_selectors
    expected = {"selector" => [['filename'],['filename']]}
    assert_equal expected, actual
  end
end