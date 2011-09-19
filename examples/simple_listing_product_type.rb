#coding: utf-8

require 'prawn_report.rb'
require 'yaml'

class ProductTypeListing < PrawnReport::SimpleListing
  
  def initialize
    super
    @params = {
      :report_name => 'Product Type Listing', 
      :listing_column => 'name'
    }
  end
  
end

data = YAML::load( File.open( File.expand_path(File.dirname(__FILE__) + "/data/product_types.yml") ) )
f = ProductTypeListing.new
puts f.draw(data)
