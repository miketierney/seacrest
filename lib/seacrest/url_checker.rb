require 'net/http'
require 'uri'
require 'timeout'

module Seacrest
  class UrlChecker
    DIR_ROOT = Dir.pwd
    DEFAULT_TIMEOUT = 20

    def self.check uri
      if uri =~ /^http/i
        check_external uri
      else
        check_internal uri
      end
    end

  private

    def self.check_external uri
      address = URI.parse(uri)

      begin
        response = Net::HTTP.get_response address
      rescue SocketError
        return false
      end

      case response.header.code
      when '200'
        true
      when /^3/
        UrlChecker.check response.header['Location']
      else
        false
      end
    end

    def self.check_internal path
      location = DIR_ROOT + path

      if File.exists?(location)

        # See if we can find index.html if it is a directory
        if File.directory?(location)
          return File.exists?("#{location}/index.html")
        end

        true
      end
    end

  end
end