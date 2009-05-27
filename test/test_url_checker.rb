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
    assert Seacrest::UrlChecker.check('/assets/csscrubber.html'), "Didn't get true back from check"
  end
  
  def test_false_on_bad_internal_path
    assert ! Seacrest::UrlChecker.check('/abbazabba/youremyonlyfriend.html'), "Didn't get false back from check"
  end

end