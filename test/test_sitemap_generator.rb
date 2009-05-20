require 'test/unit'
require 'sitemap_generator'

class TestSitemapGenerator < Test::Unit::TestCase
  def setup
    @sg = SitemapGenerator.new
    Dir.mkdir 'test/traverse'
    Dir.mkdir 'test/traverse/again'
    first = File.new 'test/traverse/first.html', 'w'; first.close
    second = File.new 'test/traverse/again/second.html', 'w'; second.close
  end
  
  def teardown
    FileUtils.rmtree 'test/traverse'
  end
  
  def test_stores_files_recursively_through_traverse
    expected = [
      'first.html',
      'again/second.html'
      ]
    assert_equal expected, @sg.traverse('test/traverse')
  end
  
  def test_new_pages_get_added_to_sitemap
    
  end
end