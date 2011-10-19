require File.expand_path(File.dirname(__FILE__) + "/../product_type_break_by_group")

data = YAML::load( File.open( File.expand_path(File.dirname(__FILE__) + "/../data/product_types_inventory.yml") ) )
f = ProductTypeBreakByGroup.new
puts f.draw(data)
