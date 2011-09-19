#coding: utf-8

require 'prawn_report.rb'

class ProductTypeListing < PrawnReport::SimpleListing
  
  def initialize
    super
    @params = {:report_name => 'Product Type Listing'}
  end
  
end

data = YAML::load( File.open( File.expand_path(File.dirname(__FILE__) + "/data/product_types.yml") ) )
f = ProductTypeListing.new
puts f.draw(data)
