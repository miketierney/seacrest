require 'test/unit'
require 'sitemap_generator'

class TestSitemapGeneratorDefaults < Test::Unit::TestCase
  def setup
    Dir.mkdir 'test/traverse'
    Dir.mkdir 'test/traverse/down'
    first = File.new 'test/traverse/first.html', 'w'; first.close
    second = File.new 'test/traverse/down/second.html', 'w'; second.close
    # sitemap = File.new 'test/traverse/sitemap.xml', 'w'
    # builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do
    #   urlset {
    #     url {
    #       loc 'first.html'
    #       priority '1.0'
    #       changefreq 'daily'
    #     }
    #   }
    # end
    # builder.default_namespace = 'http://www.sitemaps.org/schemas/sitemap/0.9'
    # sitemap.puts builder.to_xml
    # sitemap.close
    # @sg = SitemapGenerator.new 'test/traverse'
    SitemapGenerator::CONFIG.clear
  end

  def teardown
    FileUtils.rmtree 'test/traverse'
  end

  def test_defaults_not_added_without_activation
    actual = 0
    @sg = SitemapGenerator.new 'test/traverse'
    @sg.sitemap.css('urlset > url:last-child > *').each do |node|
      actual += 1
    end
    assert_equal 1, actual
  end

  def test_priority_added_with_activation
    SitemapGenerator::CONFIG['priority'] = 0.5
    @sg = SitemapGenerator.new 'test/traverse'
    assert_equal '0.5', @sg.sitemap.css('urlset > url:last-child > priority').text
  end

  def test_changefreq_added_with_activation
    SitemapGenerator::CONFIG['changefreq'] = 'weekly'
    @sg = SitemapGenerator.new 'test/traverse'
    assert_equal 'weekly', @sg.sitemap.css('urlset > url:last-child > changefreq').text
  end

  def test_validation_option_adds_extra_headers
    SitemapGenerator::CONFIG['validate'] = 'true'
    @sg = SitemapGenerator.new 'test/traverse'
    expected = {
      "xmlns:xsi:schemaLocation" => "http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd",
      "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance"
    }
    assert_equal expected, @sg.sitemap.namespaces
  end
end