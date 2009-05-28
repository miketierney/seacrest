require 'helper'

class TestCSS < Test::Unit::TestCase
  # Not too many tests to be written here just yet, since it's mostly just utilizing CSSpool, and that's not my responsibility to test.
  def setup
    @parser = CSS::SAC::Parser.new(Seacrest::Collectors::CSSHandler.new)
  end
  
  def test_start_selector
    actual = @parser.parse(File.read("#{ASSET_DIR}/csscrubber.css"))
    expected = ['body','a:link','a:visited','a:hover','a:active','div.message','.info','.info.message','em','.ampersand','.info','.message', '#call_to_action']
    assert_equal expected, actual.selectors
  end
end