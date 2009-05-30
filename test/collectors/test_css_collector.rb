require 'helper'

include Collectors

class TestCSSCollector < Test::Unit::TestCase
  def setup
    @css_file = "#{ASSET_DIR}/csscrubber.css"
    # Testing the Document Handler
    @parser = CSS::SAC::Parser.new(Collectors::CSSHandler.new)
    
    # Testing the Collector
    @my_css = Collectors::CSSCollector.new
    @my_css.process @css_file
  end
  
  def test_start_selector
    actual = @parser.parse(File.read(@css_file))
    expected = ['body','p','a:link','a:visited','a:hover','a:active','div.message','.info','.info.message','em','.ampersand','.info','.message', '#call_to_action', '.info']
    assert_equal expected, actual.selectors
  end

  def test_handles_css
    new_css = Collectors::CSSCollector.new
    assert new_css.handles?(@css_file), "Should be return a 'true' response to handling a CSS file"
  end

  def test_doesnt_handle_html
    html = Collectors::CSSCollector.new
    assert ! html.handles?("#{ASSET_DIR}/csscrubber.html"), "Should be return a 'false' response to handling any other file"
  end
  
  def test_unique_selectors_hash_gets_populated
    actual = @my_css.unique_selectors
    expected = {
      # 'body' => ['csscrubber.css', 1],
      # 'p' => ['csscrubber.css', 7],
      # 'a:link' => ['csscrubber.css', 11],
      # 'a:visited' => ['csscrubber.css', 11],
      # 'a:hover' => ['csscrubber.css', 19],
      # 'a:active' => ['csscrubber.css', 19],
      # 'div.message' => ['csscrubber.css', 21],
      # '.info' => ['csscrubber.css', 29],
      # '.info.message' => ['csscrubber.css', 36],
      # 'em' => ['csscrubber.css', 36],
      # '.ampersand' => ['csscrubber.css', 36],
      # '.message' => ['csscrubber.css', 46],
      # '#call_to_action' => ['csscrubber.css', 53]
      'body' => ['csscrubber.css'],
      'p' => ['csscrubber.css'],
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
  
  def test_dup_selectors_hash_gets_populated
    actual = @my_css.dup_selectors
    # expected = {'.info' => [ ['csscrubber.css', 24], ['csscrubber.css', 37] ] }
    expected = {'.info' => [ ['csscrubber.css'], ['csscrubber.css'], ['csscrubber.css'] ] }
    assert_equal expected, actual
  end

  def test_all_selectors
    actual = @my_css.all_selectors
    expected = ['body','p','a:link','a:visited','a:hover','a:active','div.message','.info','.info.message','em','.ampersand','.info','.message', '#call_to_action', '.info']
    assert_equal expected, actual
  end
  
end