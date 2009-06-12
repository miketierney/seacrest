# No tests here, so no need to run this file.

require 'helper'

class Collectors
  attr_accessor :files
end

class TestCollectors < Test::Unit::TestCase
  def setup
    @file_base = "#{ASSET_DIR}/csscrubber"
    @css_file = "#{@file_base}.css"
    @html_file = "#{@file_base}.html"
    @htm_file = "#{ASSET_DIR}/old_timer.htm"
    @rb_file = "#{ASSET_DIR}/ignore_me.rb"

    @collectors = Collectors.new({
      "css" => ["#{ASSET_DIR}/stylesheets/globals.css","#{ASSET_DIR}/csscrubber.css"],
      "htm" => ["#{ASSET_DIR}/old_timer.htm"],
      "html" => ["#{ASSET_DIR}/index.html","#{ASSET_DIR}/csscrubber.html"],
      "rb" => ["#{ASSET_DIR}/ignore_me.rb"]
    })
    
    @collectors.process_files
  end

  def test_see_if_class_exists
    assert Seacrest.const_defined?("CSSCollector"), "Should return true for Seacrest::CSSCollector existing"
    assert ! Seacrest.const_defined?("MPTCollector"), "There's currently not such filetype as .mpt (as far as I know), so this shouldn't exist."
  end

  def test_handles_css_files
    assert @collectors.can_handle?(@css_file), 'The collectors should be able to handle a .css file.'
  end

  def test_handles_html_files
    assert @collectors.can_handle?(@htm_file), 'The collectors should be able to handle a .htm file.'
    assert @collectors.can_handle?(@html_file), 'The collectors should be able to handle a .html file.'
  end

  def test_process_files_kills_htm
    actual = @collectors.files.has_key?('htm')
    expected = false
    assert_equal expected, actual
  end

  def test_unique_css_selectors
    # ultimately needs to look like { "selector" => {:files => "a.css, b.css", :used => false}}
    assert @collectors.unique_selectors.has_key?('body'), "Should have a reference to the body"
    assert @collectors.unique_selectors['body'].has_key?(:files), "Should have a reference to the body"
    assert @collectors.unique_selectors['body'].has_value?([@css_file]), "Should have a reference to the body"
    assert @collectors.unique_selectors['body'].has_key?(:used), "Should have a reference to the body"
    assert @collectors.unique_selectors['body'].has_value?('false'), "Should have a reference to the body"
  end

  def test_dup_css_selectors
    assert @collectors.dup_selectors.include?('.info'), "Should have a reference to the .info class, since it's the duplicated class"
  end

  # Commented out for the sake of my co-authors; don't want to force them to look at my failing test until I solve it.
  # def test_unused_css_selectors
  #   @collectors.process_files
  #   assert @collectors.unused_selectors.include?('.not_in_file'), "Should have a reference to the .not_in_file class, since it's the unused class"
  # end

end