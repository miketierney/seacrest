require 'net/http'
require 'uri'
require 'nokogiri'
require 'timeout'

module Seacrest
  class UrlChecker
    DIR_ROOT = Dir.pwd
    DEFAULT_TIMEOUT = 20 # Seconds

    #      {'tag' => 'link_attribute'}
    TAGS = {'a'   => 'href',
            'img' => 'src'}

    def self.validate file
      links = get_links file

      links.each do |link, lines|
        status = check(link) ? "good" : "bad"
        puts "#{lines.join(', ')}: #{link} is #{status}"
      end
      nil
    end

  private

    def self.check uri
      if uri =~ /^http/i
        check_external uri
      else
        check_internal uri
      end
    end

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
        # So we don't get caught in an endless redirect loop
        return false if redirects >= 5

        location = response.header['Location']

        if location =~ /^\//
          location = "#{address.scheme}://#{address.host}#{location}"
        end

        UrlChecker.check_external location, redirects + 1

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

      TAGS.each do |tag, attribute|
        html.css(tag).each { |link| links[link[attribute]] += [link.line]}
      end

      links
    end

  end
end