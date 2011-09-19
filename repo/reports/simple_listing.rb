#coding: utf-8

require File.expand_path(File.dirname(__FILE__) + "/../../lib/report.rb")
require File.expand_path(File.dirname(__FILE__) + "/../bands/headers/header_001.rb")
require File.expand_path(File.dirname(__FILE__) + "/../bands/footers/footer_001.rb")


module PrawnReport
  class SimpleListing < Report

    def initialize
      super
      @header_class = PrawnReport::Header001
      @footer_class = PrawnReport::Footer001      
    end
    
    protected
    
    def draw_internal
      @data['items'].each do |i|
        new_page unless fits?(17)
        text(i[@params[:listing_column]], 100, :font_size => 14, :style => :italic)
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
end
