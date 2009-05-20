require 'net/http'
require 'uri'
require 'timeout'

module Seacrest
  class UrlChecker

    def self.check uri
      address = URI.parse(uri)

      begin
        response = Net::HTTP.get_response address
      rescue SocketError
        return false
      end
      
      case response.header.code
      when '200'
        true
      else
        false
      end
    end

  end
end