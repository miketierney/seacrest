require 'helper'

class TestUrlChecker < Test::Unit::TestCase
  # TODO: mock Net::HTTP.get_response
  def test_true_on_good_external_link
    assert Seacrest::UrlChecker.check('http://www.apple.com')
  end
  
  def test_false_on_bad_url
    assert ! Seacrest::UrlChecker.check('http://asdf.asdfasdf.asdf')
  end

  def test_handles_301
    
  end
  
  def test_handles_302
    
  end
end