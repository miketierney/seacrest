require 'test/unit'
require 'sitemap_generator'

class TestSitemapGenerator < Test::Unit::TestCase
  def setup
    @sg = SitemapGenerator.new
    Dir.mkdir 'test/traverse'
    Dir.mkdir 'test/traverse/again'
    first = File.new 'test/traverse/first.html', 'w'; first.close
    second = File.new 'test/traverse/again/second.html', 'w'; second.close
    sitemap = File.new 'test/traverse/sitemap.xml', 'w'
    builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do
      urlset(:xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9') {
        url {
          loc 'first.html'
        }
      }
    end
    sitemap.puts builder.to_xml
    sitemap.close
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
  
  def test_sitemap_xml_file_gets_ignored
    pages = @sg.traverse('test/traverse')
    assert_not_equal 'sitemap.xml', pages.detect { |p| p == 'sitemap.xml' }
  end
  
  def test_new_pages_get_added_to_sitemap
    assert_match /(<loc>again\/second.html<\/loc>)/, @sitemap
  end
end