require 'helper'

class TestCSS < Test::Unit::TestCase
  def setup
    # Testing the Document Handler
    @parser = CSS::SAC::Parser.new(Seacrest::Collectors::CSSHandler.new)
    
    # Testing the Collector
    @my_css = Seacrest::Collectors::CSSCollector.new
    @my_css.parse "#{ASSET_DIR}/csscrubber.css"
  end
  
  def test_start_selector
    actual = @parser.parse(File.read("#{ASSET_DIR}/csscrubber.css"))
    expected = ['body','a:link','a:visited','a:hover','a:active','div.message','.info','.info.message','em','.ampersand','.info','.message', '#call_to_action']
    assert_equal expected, actual.selectors
  end
  
  def test_selectors_hash_gets_populated
    actual = @my_css.unique_selectors
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
  
  def test_all_selectors
    actual = @my_css.all_selectors
    expected = ['body','a:link','a:visited','a:hover','a:active','div.message','.info','.info.message','em','.ampersand','.info','.message', '#call_to_action']
    assert_equal expected, actual
  end
  
end