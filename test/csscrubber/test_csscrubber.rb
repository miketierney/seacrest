require 'helper'

class TestCSScrubber < Test::Unit::TestCase
  def setup
    @css = "#{ASSET_DIR}/csscrubber.css"
    @html = "#{ASSET_DIR}/csscrubber.html"
    @scrubber = Seacrest::CSScrubber.new ASSET_DIR
    
    @scrubber.process_files
  end

  def test_asset_directory_exists # 'cause I created it, and I want to make sure that this actually works.  Will fail if the stuff doesn't exist.
    assert File.exist?(@html), "CSScrubber html file should exist."
  end
  
  def test_stores_files_recursively_through_traverse
    assert @scrubber.files.has_key?('css'), "Should store CSS files"
    assert @scrubber.files.has_value?(["#{ASSET_DIR}/stylesheets/globals.css","#{ASSET_DIR}/csscrubber.css"]), "Should store the CSS filenames"
    
    assert @scrubber.files.has_key?('html'), "Should store HTML files"
    assert @scrubber.files.has_value?(["#{ASSET_DIR}/index.html","#{ASSET_DIR}/csscrubber.html","#{ASSET_DIR}/old_timer.htm"]), "Should store the HTML filenames"
    
    assert @scrubber.files.has_key?('rb'), "Should store RB files"
    assert @scrubber.files.has_value?(["#{ASSET_DIR}/ignore_me.rb"]), "Should store the RB filenames"
  end
  
  def test_stores_unique_selectors
    assert @scrubber.unique_selectors.has_key?('body'), "Should include the body tag."
    assert @scrubber.unique_selectors.has_key?('.info'), "Should include the .info selector."
    assert @scrubber.unique_selectors.has_key?('.info.message'), "Should include the .info.message selector."
    assert @scrubber.unique_selectors.has_key?('.not_in_file'), "Should include the .not_in_file selector."
    assert @scrubber.unique_selectors.has_key?('ul li:first-child'), "Should include the ul li:first-child selector."
  end
  
  def test_unique_selectors_stores_state
    assert @scrubber.unique_selectors['.not_in_file'].has_value?(false), "Should show 'false' for at least one selector, since that is the default state."
    assert @scrubber.unique_selectors['body'].has_value?(true), "Should show 'true' for at least one selector, since that should be set during the processing."
  end
  
  def test_stores_all_selectors
    assert @scrubber.all_selectors.include?('body'), "Should include the body tag."
    assert @scrubber.all_selectors.include?('.info.message'), "Should include the .info.message selector."
    assert @scrubber.all_selectors.include?('.not_in_file'), "Should include the .not_in_file selector."
    assert @scrubber.all_selectors.include?('ul li:first-child'), "Should include the ul li:first-child selector."
  end
  
  def test_all_selectors_stores_duplicates
    dup_count = 0
    
    @scrubber.all_selectors.each do |i|
      if i == ".info"
        dup_count += 1
      end
    end
    
    actual = dup_count
    expected = 4
    assert_equal expected, actual
  end
  
  def test_stores_unused_selectors
    assert @scrubber.unused_selectors.include?('.not_in_file'), "Should include the .not_in_file selector."
    assert !@scrubber.unused_selectors.include?('.message'), "Should NOT include the .message selector."
  end
  
  def test_stores_duplicate_selectors
    assert @scrubber.dup_selectors.has_key?(".info"), "Should include the .info selector."
    assert @scrubber.dup_selectors['.info'].include?('csscrubber.css'), "Should include the .info selector files."
    assert @scrubber.dup_selectors['.info'].include?('globals.css'), "Should include the .info selector files."
  end
  
  def test_dup_unused_dont_overwrite_one_another
    assert @scrubber.unused_selectors.include?('#call_to_action'), "Should include the #call_to_action selector."
    assert @scrubber.dup_selectors.include?('#call_to_action'), "#call_to_action lives in both csscrubber.css and globals.css, and isn't used in any HTML file."
    
    actual = @scrubber.dup_selectors['#call_to_action']
    expected = ['globals.css','csscrubber.css']
    assert_equal expected, actual
  end

  def test_dup_unused_shouldnt_overwrite_one_another
    assert @scrubber.unused_selectors.include?('.arbitrary_class'), "Should include the .arbitrary_class selector."
    assert @scrubber.dup_selectors.include?('.arbitrary_class'), ".arbitrary_class lives in both csscrubber.css and globals.css, and isn't used in any HTML file."
    
    actual = @scrubber.dup_selectors['.arbitrary_class']
    expected = ['globals.css','csscrubber.css']
    assert_equal expected, actual
  end

  
  def test_dup_unused_really_doesnt_overwrite_one_another
    assert @scrubber.unused_selectors.include?('.info'), "Should include the #call_to_action selector."
    assert @scrubber.dup_selectors.include?('.info'), "#call_to_action lives in both csscrubber.css and globals.css, and isn't used in any HTML file."
    
    actual = @scrubber.dup_selectors['.info']
    expected = ['globals.css','csscrubber.css']
    assert_equal expected, actual
  end
  
end