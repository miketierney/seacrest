# -*- ruby -*-

require 'rubygems'
require 'hoe'

$: << File.join(File.dirname(__FILE__), 'lib')

require 'seacrest'

Hoe.new('seacrest', Seacrest::VERSION) do |p|
  # p.rubyforge_name = 'seacrestx' # if different than lowercase project name
  p.developer('Matthew Anderson', 'manderson@onehub.com')
  p.developer('Brandon Caplan', 'maelmann@gmail.com')
  p.developer('Michael Tierney', 'mike@panpainter.com')

  p.extra_deps      = ['nokogiri','>=1.2.4']
  p.extra_deps      = ['csspool','>=0.2.6']
end

# vim: syntax=Ruby
