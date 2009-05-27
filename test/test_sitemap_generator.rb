require 'test/unit'
require 'rubygems'
require 'sitemap_generator'

class TestSitemapGenerator < Test::Unit::TestCase
  def setup
    @sg = SitemapGenerator.new 'test/traverse'
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
  
  def test_existing_pages_stay_put
    assert_match /(<priority>1.0<\/priority>)/, @sitemap
  end
  
  def test_validation_option_adds_extra_headers
    assert_match /(xmlns:xsi="http:\/\/www.w3.org\/2001\/XMLSchema-instance")/, @sitemap, "We're missing the xmlns:xsi header"
    assert_match /(xsi:schemaLocation="http:\/\/www.sitemaps.org\/schemas\/sitemap\/0.9 http:\/\/www.sitemaps.org\/schemas\/sitemap\/0.9\/sitemap.xsd")/, @sitemap, "We're missing xsi:schemaLocation header"
  end
  
  def test_priority_default_adds_tag
    assert_match /<priority>0.5<\/priority>/, @sitemap
  end
  
  def test_changefreq_default_adds_tag
    assert_match /<changefreq>weekly<\/changefreq>/, @sitemap
  end
end