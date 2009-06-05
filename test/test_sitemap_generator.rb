require 'test/unit'
require 'sitemap_generator'

class SitemapGenerator
  CONFIG = {}
end

class TestSitemapGenerator < Test::Unit::TestCase
  def setup
    Dir.mkdir 'test/traverse'
    Dir.mkdir 'test/traverse/down'
    first = File.new 'test/traverse/first.html', 'w'; first.close
    second = File.new 'test/traverse/down/second.html', 'w'; second.close
    sitemap = File.new 'test/traverse/sitemap.xml', 'w'
    builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do
      urlset {
        url {
          loc 'first.html'
          priority '1.0'
          changefreq 'daily'
        }
      }
    end
    builder.default_namespace = 'http://www.sitemaps.org/schemas/sitemap/0.9'
    sitemap.puts builder.to_xml
    sitemap.close
    @sg = SitemapGenerator.new 'test/traverse'
    SitemapGenerator::CONFIG.clear
  end

  def teardown
    FileUtils.rmtree 'test/traverse'
  end

  def test_stores_files_recursively_through_traverse
    expected = [
      'first.html',
      'down/second.html'
    ]
    assert_equal expected, @sg.pages
  end

  def test_sitemap_xml_file_gets_ignored
    assert_equal false, @sg.pages.include?('sitemap.xml')
  end

  def test_stores_existing_pages
    expected = {
      'first.html' => {
        :priority => '1.0',
        :changefreq => 'daily'
      }
    }
    assert_equal expected, @sg.existing_pages
  end

  def test_existing_pages_stay_put
    expected = [
      'first.html',
      '1.0',
      'daily'
    ]
    actual = []
    @sg.sitemap.css('urlset > url:first-child > *').each do |node|
      actual << node.text
    end
    assert_equal expected, actual
  end

  def test_new_pages_get_added_to_sitemap
    assert_equal 'down/second.html', @sg.sitemap.css('urlset > url:last-child > loc').text
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