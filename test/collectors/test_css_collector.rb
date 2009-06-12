require 'helper'

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

  def test_unique_selectors_hash_gets_populated
    assert @my_css.unique_selectors.has_key?('body'), "Should have a reference to the body"
    assert @my_css.unique_selectors['body'].has_key?(:files), "Body should have a key for the files"
    assert @my_css.unique_selectors['body'].has_value?(['csscrubber.css']), "Body should have an array of the files this selector can be found in"
    assert @my_css.unique_selectors['body'].has_key?(:used), "Body should have a key for the state"
    assert @my_css.unique_selectors['body'].has_value?(false), "Body should have boolean for the state of the selector"

  end

  def test_dup_selectors_hash_gets_populated
    actual = @my_css.dup_selectors
    expected = {'.info' => ['csscrubber.css'] }
    assert_equal expected, actual
  end

  def test_all_selectors
    actual = @my_css.all_selectors
    expected = ['body','p','a:link','a:visited','a:hover','a:active','div.message','.info','.info.message','em','.ampersand','.info','.message', '#call_to_action', '.info']
    assert_equal expected, actual
  end

end