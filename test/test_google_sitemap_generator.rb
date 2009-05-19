require 'test/unit'

require 'google_sitemap_generator'

class TestGoogleSitemapGenerator < Test::Unit::TestCase
  def setup
    @gsg = GoogleSitemapGenerator.new
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
      'again/second.html',
      'first.html'
      ]
    assert_equal expected, @gsg.traverse(Dir.pwd + "/test/traverse")
  end
end