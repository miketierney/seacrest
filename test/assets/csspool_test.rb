# run this from the command line with ruby csspool_test.rb filename.css and it will ouptut all of the selectors in a css file
require 'rubygems'
require 'csspool'

class DH < CSS::SAC::DocumentHandler
  def start_selector(selectors)
    puts selectors.map { |x| x.to_css }
  end
end

parser = CSS::SAC::Parser.new(DH.new)
parser.parse(File.read(ARGV[0]))