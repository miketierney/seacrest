require 'helper'

module Seacrest::UrlChecker::Net
  class HTTP
    @@got_response = []
    @@respond_with = []

    def self.got_response
      @@got_response.pop
    end

    def self.respond_with object, expected = nil
      @@respond_with << [object, expected]
    end

    def self.get_response url
      response, expectation = @@respond_with.pop

      if expectation
        raise "Does not match expectation" unless url == expectation
      end

      @@got_response << url
      response
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

  def setup
    # Silence!
    $stdout = StringIO.new
  end

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

  def test_handles_relative_redirect
    Seacrest::UrlChecker::Net::HTTP.respond_with FakeResponse.new(FakeHeader.new('200')), 'http://www.apple.com/back_to_school'
    Seacrest::UrlChecker::Net::HTTP.respond_with FakeResponse.new(FakeHeader.new('301', {'Location' => '/back_to_school'}))

    assert Seacrest::UrlChecker.check('http://www.apple.com/backtoschool'), "Didn't get true back from check"
  end

  def test_prevents_too_many_redirects
    5.times do
      Seacrest::UrlChecker::Net::HTTP.respond_with FakeResponse.new(FakeHeader.new('301', {'Location' => 'http://www.apple.com'}))
    end

    assert ! Seacrest::UrlChecker.check('http://www.apple.com/back'), "Didn't get false after 5 redirects"
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
    file = './test/assets/index.html'
    expected = {'http://www.onehub.com' => [6], 'http://www.apple.com' => [7, 8]}
    actual = Seacrest::UrlChecker.get_links file

    assert_equal expected, actual
  end

end