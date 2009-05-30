# No tests here, so no need to run this file.

require 'helper'

class TestCollectors < Test::Unit::TestCase
  def setup
    @collectors = Collectors
    @file_base = "#{ASSET_DIR}/csscrubber"
    @css_file = "#{@file_base}.css"
    @html_file = "#{@file_base}.html"
    @htm_file = "#{@file_base}.htm"
  end
  
  def test_see_if_class_exists
    assert Collectors.const_defined?("CSSCollector"), "Should return true for Collectors::CSSCollector existing"
    assert ! Collectors.const_defined?("MPTCollector"), "There's currently not such filetype as .mpt (as far as I know), so this shouldn't exist."
  end
  
  def test_handles_css_files
    assert @collectors.can_handle?(@css_file), 'The collectors should be able to handle a .css file.'
  end
  
  def test_handles_html_files
    assert @collectors.can_handle?(@htm_file), 'The collectors should be able to handle a .htm file.'
    assert @collectors.can_handle?(@html_file), 'The collectors should be able to handle a .html file.'
  end
end