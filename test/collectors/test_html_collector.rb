require 'helper'

class TestHTMLCollector < Test::Unit::TestCase
  def setup
    @my_html = HTMLCollector.new
    @html_file = "#{ASSET_DIR}/csscrubber.html"
    @selectors = ['body', 'h2', '.not_in_file', '.not_in_file']
    @unique_selectors = {
      'body'            => {:files => 'csscrubber.css', :used => false },
      'h2'              => {:files => 'csscrubber.css', :used => false },
      '.not_in_file'    => {:files => 'csscrubber.css', :used => false }
    }
    
    @my_html.selectors = @selectors
    @my_html.unique_selectors = @unique_selectors
  end

  def test_process_html_doesnt_explode
    assert @my_html.process(@html_file), "Doesn't blow up when I ask it to process a file"
  end

  def test_unused_selectors_gets_populated
    @my_html.process(@html_file)
    
    actual = @my_html.unused_selectors
    expected = ['.not_in_file']
    assert_equal expected, actual
  end
end
