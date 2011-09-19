#coding: utf-8

require 'yaml'

require File.expand_path(File.dirname(__FILE__) + "/../lib/report.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/bands/header_001.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/bands/footer_001.rb")

class ProductTypeListing < PrawnReport::Report
  def initialize
    super
    @header_class = PrawnReport::Header001
    @footer_class = PrawnReport::Footer001
    @params = {:report_name => 'Product Type Listing'}
  end
  
  protected
  
  def draw_internal
    @data['product_types'].each do |pt|
      new_page unless fits?(17)
      text(pt['name'], 100, :font_size => 14, :style => :italic)
      line_break(17)
    end
  end
  
  def second_pass
    1.upto(@num_pages) do |i|
      @pdf.go_to_page(i)
      @pdf.move_cursor_to(10)
      @x = 0
      text("Página #{@pdf.page_number}/#{@pdf.page_count}", @max_width, :align => :right)
    end
  end

  
end

data = YAML::load( File.open( File.expand_path(File.dirname(__FILE__) + "/data/product_types.yml") ) )
f = ProductTypeListing.new
puts f.draw(data)
