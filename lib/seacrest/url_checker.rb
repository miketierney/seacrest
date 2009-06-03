require 'net/http'
require 'uri'
require 'nokogiri'
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

    def self.check_external uri, redirects = 1
      address = URI.parse(uri)

      begin
        # TODO: add support for specifying timeout length
        response = timeout(DEFAULT_TIMEOUT) do
          Net::HTTP.get_response address
        end
      rescue SocketError, TimeoutError
        return false
      end

      case response.header.code
      when '200'
        true
      when /^3/
        return false if redirects > 4
        UrlChecker.check_external response.header['Location'], redirects + 1
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
        # We know the file exists and it wasn't a folder so return true
        return true
      end
      # The file or directory didn't exist, falls through to false
      false
    end

    def self.get_links file
      html = Nokogiri::XML(open(file))
      links = Hash.new []

      html.css('a').each { |link| links[link['href']] += [link.line]}
      links
    end

  end
end