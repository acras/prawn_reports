#coding: utf-8

#gem style
#require 'prawn_report.rb'

#dev style
require File.expand_path(File.dirname(__FILE__) + "/simple_listing_people.rb")

require 'yaml'

data = YAML::load( File.open( File.expand_path(File.dirname(__FILE__) + "/data/people.yml") ) )
f = PeopleListing.new
puts f.draw(data)
