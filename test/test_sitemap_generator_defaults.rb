require 'test/unit'
require 'sitemap_generator'

class TestSitemapGeneratorDefaults < Test::Unit::TestCase
  def setup
    Dir.mkdir 'test/traverse'
    Dir.mkdir 'test/traverse/down'
    first = File.new 'test/traverse/first.html', 'w'; first.close
    second = File.new 'test/traverse/down/second.html', 'w'; second.close
    SitemapGenerator::CONFIG.clear
    SitemapGenerator::CONFIG['priority'] = 0.5
    SitemapGenerator::CONFIG['changefreq'] = 'weekly'
    SitemapGenerator::CONFIG['validate'] = 'true'
    @sg = SitemapGenerator.new 'test/traverse'
  end

  def teardown
    FileUtils.rmtree 'test/traverse'
  end

  def test_priority_added_with_activation
    assert_equal '0.5', @sg.sitemap.css('urlset > url:last-child > priority').text
  end

  def test_changefreq_added_with_activation
    assert_equal 'weekly', @sg.sitemap.css('urlset > url:last-child > changefreq').text
  end

  def test_validation_option_adds_extra_headers
    expected = {
      "xmlns:xsi:schemaLocation" => "http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd",
      "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance"
    }
    assert_equal expected, @sg.sitemap.namespaces
  end
end