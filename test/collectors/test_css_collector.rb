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
    expected = ['body','a:link','a:visited','a:hover','a:active','div.message','.info','.info.message','em','.ampersand','.info','.message', '#call_to_action', '.info']
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
      # 'a:link' => ['csscrubber.css', 7],
      # 'a:visited' => ['csscrubber.css', 7],
      # 'a:hover' => ['csscrubber.css', 15],
      # 'a:active' => ['csscrubber.css', 15],
      # 'div.message' => ['csscrubber.css', 17],
      # '.info' => ['csscrubber.css', 24],
      # '.info.message' => ['csscrubber.css', 31],
      # 'em' => ['csscrubber.css', 31],
      # '.ampersand' => ['csscrubber.css', 31],
      # '.message' => ['csscrubber.css', 41],
      # '#call_to_action' => ['csscrubber.css', 49]
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
  
  def test_dup_selectors_hash_gets_populated
    actual = @my_css.dup_selectors
    # expected = {'.info' => [ ['csscrubber.css', 24], ['csscrubber.css', 37] ] }
    expected = {'.info' => [ ['csscrubber.css'], ['csscrubber.css'], ['csscrubber.css'] ] }
    assert_equal expected, actual
  end

  def test_all_selectors
    actual = @my_css.all_selectors
    expected = ['body','a:link','a:visited','a:hover','a:active','div.message','.info','.info.message','em','.ampersand','.info','.message', '#call_to_action', '.info']
    assert_equal expected, actual
  end
  
end