$: << File.dirname(__FILE__)

require 'rubygems'
require 'test/unit'
require 'seacrest'
require 'seacrest/url_checker'
require 'seacrest/csscrubber'

ASSET_DIR = "#{File.dirname(__FILE__)}/assets"

class Test::Unit::TestCase
  def self.focus *focused
    focused.collect! { |m| m.to_s }

    instance_methods.
      collect { |m| m.to_s }.
      select  { |m| m =~ /^test/ }.
      reject  { |m| focused.include? m }.
      each    { |m| undef_method m }
  end
end