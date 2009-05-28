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

  def test_should_detect_css_files
    actual = @scrubber.what_ext? @css
    expected = "css"
    assert_equal expected, actual
  end
  
  def test_should_detect_html_files
    actual = @scrubber.what_ext? @html
    expected = "html"
    assert_equal expected, actual
  end
  
  def test_should_warn_on_all_other_files
    actual = @scrubber.what_ext? File.dirname(__FILE__)
    expected = "The file you supplied, #{File.dirname(__FILE__)}, is not a valid HTML or CSS file.  Please enter another file."
    assert_equal expected, actual
  end
  
  def test_should_warn_on_exceptions
    actual = @scrubber.what_ext? "massive_fail.html"
    expected = "The file you supplied, massive_fail.html, is not a valid file; it either may not exist, or it may have been a directory."
    assert_equal expected, actual
  end
  
  def test_css_eh
    css = File.extname(@css).gsub('.','')
    html = File.extname(@html).gsub('.','')
    assert css.css?, "Should return true, since it's a CSS file"
    assert ! html.css?, "Should return false, since it's an HTML file"
  end
  
  def test_html_eh
    css = File.extname(@css).gsub('.','')
    html = File.extname(@html).gsub('.','')
    assert ! css.html?, "Should return false, since it's a CSS file"
    assert html.html?, "Should return true, since it's an HTML file"
  end
  
  def test_reads_files
    assert @scrubber.read_file(@css), "should be able to open the css file with no problems."
    assert @scrubber.read_file(@html), "should be able to open the html file with no problems."
  end
  
  def test_selectors_hash_gets_populated
    @scrubber.parse_css
    actual = @scrubber.selectors
    expected = {
      'body' => ['csscrubber.css'],
      'a:link' => ['csscrubber.css'],
      'a:visited' => ['csscrubber.css'],
      'a:hover' => ['csscrubber.css'],
      'a:active' => ['csscrubber.css'],
      'div.message' => ['csscrubber.css'],
      '.info' => ['csscrubber.css'],
      '.info.message' => ['csscrubber.css'],
      'em' => ['csscrubber.css'],
      '.ampersand' => ['csscrubber.css'],
      '.message' => ['csscrubber.css'],
      '#call_to_action' => ['csscrubber.css']
    }
    assert_equal expected, actual
  end

  # This is kind of redundant with the test over in collectors/test_css, but I want to make sure that my modules are talking to each other ...
  def test_all_selectors
    @scrubber.parse_css
    actual = @scrubber.all_selectors
    expected = ['body','a:link','a:visited','a:hover','a:active','div.message','.info','.info.message','em','.ampersand','.info','.message', '#call_to_action']
    assert_equal expected, actual
  end
end