require 'helper'

class TestHTMLCollector < Test::Unit::TestCase
  def setup
    @my_html = Seacrest::Collectors::HTMLCollector.new
    @html_file = "#{ASSET_DIR}/csscrubber.html"
  end
  
  # This test is mostly to get me up and running on a few different other fronts; just want to make sure that I can actually access my HTMLCollector class right now.
  def test_is_html
    assert @my_html.handles?(@html_file), "Detecting that the file is actually an HTML file."
  end
end
