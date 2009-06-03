require 'test/unit'
require 'sitemap_generator'

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
    sitemap.puts builder.to_xml
    sitemap.close
    @sg = SitemapGenerator.new 'test/traverse'
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
    @sg.sitemap.xpath('/urlset/url[1]/*').each do |node|
      actual << node.text
    end
    assert_equal expected, actual
  end

  def test_new_pages_get_added_to_sitemap
    expected = [
      'down/second.html'
    ]
    actual = []
    @sg.sitemap.xpath('/urlset/url[2]/*').each do |node|
      actual << node.text
    end
    assert_equal expected, actual
  end

  def test_priority_default_adds_tag
    assert_match /<priority>0.5<\/priority>/, @sitemap
  end

  def test_changefreq_default_adds_tag
    assert_match /<changefreq>weekly<\/changefreq>/, @sitemap
  end

  def test_validation_option_adds_extra_headers
    assert_match /(xmlns:xsi="http:\/\/www.w3.org\/2001\/XMLSchema-instance")/, @sitemap, "We're missing the xmlns:xsi header"
    assert_match /(xsi:schemaLocation="http:\/\/www.sitemaps.org\/schemas\/sitemap\/0.9 http:\/\/www.sitemaps.org\/schemas\/sitemap\/0.9\/sitemap.xsd")/, @sitemap, "We're missing xsi:schemaLocation header"
  end
end