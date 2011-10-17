require File.expand_path(File.dirname(__FILE__) + "/../simple_listing_product_type")

data = YAML::load( File.open( File.expand_path(File.dirname(__FILE__) + "/../data/product_types.yml") ) )
f = ProductTypeListing.new
puts f.draw(data)
