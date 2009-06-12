require 'helper'

class TestSitemapGeneratorDefaults < Test::Unit::TestCase
  def setup
    Dir.mkdir 'test/traverse'
    Dir.mkdir 'test/traverse/down'
    first = File.new 'test/traverse/first.html', 'w'; first.close
    second = File.new 'test/traverse/down/second.html', 'w'; second.close
    Seacrest::SitemapGenerator::CONFIG.clear
    Seacrest::SitemapGenerator::CONFIG['priority'] = 0.5
    Seacrest::SitemapGenerator::CONFIG['changefreq'] = 'weekly'
    Seacrest::SitemapGenerator::CONFIG['validate'] = 'true'
    @sg = Seacrest::SitemapGenerator.new 'test/traverse'
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
      "xmlns"=>"http://www.sitemaps.org/schemas/sitemap/0.9",
      "xmlns:xsi:schemaLocation" => "http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd",
      "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance"
    }
    assert_equal expected, @sg.sitemap.namespaces
  end
end