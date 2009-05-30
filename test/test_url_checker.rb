require 'helper'

module Seacrest::UrlChecker::Net
  class HTTP
    @@got_response = []
    @@respond_with = []
    def self.got_response
      @@got_response.pop
    end

    def self.respond_with object
      @@respond_with << object
    end

    def self.get_response url
      @@got_response << url
      @@respond_with.pop
    end
  end
end

class FakeResponse
  attr_reader :header

  def initialize header
    @header = header
  end
end

class FakeHeader
  attr_reader :code

  def initialize code, hash = {}
    @code = code
    @hash = hash
  end

  def [] key
    @hash[key]
  end

  def header
    self
  end

end


class TestUrlChecker < Test::Unit::TestCase

  def test_true_on_good_external_url
    Seacrest::UrlChecker::Net::HTTP.respond_with FakeResponse.new(FakeHeader.new('200'))
    assert Seacrest::UrlChecker.check('http://www.apple.com'), "Didn't get true back from check"
  end

  def test_false_on_bad_external_url
    Seacrest::UrlChecker::Net::HTTP.respond_with FakeResponse.new(FakeHeader.new('404'))
    assert ! Seacrest::UrlChecker.check('http://www.badapple.com'), "Didn't get false back from check"
  end

  def test_handles_3xx_redirect
    Seacrest::UrlChecker::Net::HTTP.respond_with FakeResponse.new(FakeHeader.new('200'))
    Seacrest::UrlChecker::Net::HTTP.respond_with FakeResponse.new(FakeHeader.new('301', {'Location' => 'http://www.apple.com'}))

    assert Seacrest::UrlChecker.check('http://www.apple.com/back'), "Didn't get true back from check"
  end

  def test_true_on_internal_path
    assert Seacrest::UrlChecker.check('/test/assets/csscrubber.html'), "Didn't get true back from check"
  end

  def test_false_on_bad_internal_path
    assert ! Seacrest::UrlChecker.check('/abbazabba/youremyonlyfriend.html'), "Didn't get false back from check"
  end

  def test_looks_for_index_when_given_directory
    assert Seacrest::UrlChecker.check('/test/assets/'), "Couldn't find index.html in #{Dir.pwd}/test/assets/"
  end

  def test_gets_links_and_lines_from_html
    file =  StringIO.new(%(<html>
      <head>
        <title>test test</title>
      </head>
      <body>
        <div>adfsadf<a href="http://www.onehub.com">onehub</a></div>
        <a href="http://www.apple.com">apple</a>
        <a href="http://www.apple.com">apple</a>
      </body>
    </html>))

    expected = {'http://www.onehub.com' => [6], 'http://www.apple.com' => [7, 8]}

    actual = Seacrest::UrlChecker.get_links file

    assert_equal expected, actual
  end

end