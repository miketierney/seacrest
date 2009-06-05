require 'net/http'
require 'uri'
require 'nokogiri'
require 'timeout'
require 'thread'

module Seacrest
  class UrlChecker
    DIR_ROOT = Dir.pwd
    DEFAULT_TIMEOUT = 20 # Seconds

    #      {'tag' => 'link_attribute'}
    TAGS = {'a'   => 'href',
            'img' => 'src'}

    def self.validate file
      links = get_links file
      queue = Queue.new
      mutex = Mutex.new
      thread_pool = []
      output = ''

      links.sort { |a, b| a[1]<=>b[1] }.each do |link|
        queue << link
      end

      5.times {
        thread_pool << Thread.new do
          mutex.synchronize {
          until queue.empty?
            output << generate_output(queue.pop)
          end
          }
        end
      }

      thread_pool.each { |t| t.join }

      print output
    end

  private

    def self.generate_output link_info
      link, lines = link_info
      status = check(link) ? "good" : "bad"

      "#{lines.join(', ')}: #{link} is #{status}\n"
    end

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

      links.each { |link, lines| lines.uniq!}
      links
    end

  end
end