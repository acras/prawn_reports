#coding: utf-8

require File.expand_path(File.dirname(__FILE__) + "/../../lib/report.rb")
require File.expand_path(File.dirname(__FILE__) + "/../bands/headers/header_001.rb")
require File.expand_path(File.dirname(__FILE__) + "/../bands/headers/header_002.rb")
require File.expand_path(File.dirname(__FILE__) + "/../bands/footers/footer_001.rb")


module PrawnReport
  class SimpleListing < Report

    def initialize
      super
      @header_class = PrawnReport::Header001
      @header_other_pages_class = PrawnReport::Header002       
      @footer_class = PrawnReport::Footer001
    end
    
    protected
    
    def draw_internal
      if @params[:field]
        render_one_column_title
      elsif @params[:columns]
        render_multi_column_title
      end
      @data['items'].each do |row|
        new_page unless fits?(15)
        render_line(row)
        line_break(15)
      end
    end
    
    def render_line(row)
      if @params[:field]
        render_one_column_line(row)
      elsif @params[:columns]
        render_multi_column_line(row)
      end
    end
    
    def render_one_column_title
      if @params[:title]
        text(@params[:title], @max_width, :font_size => 14, :style => :bold)
        line_break(15)
      end
    end
    
    def render_multi_column_title
      @params[:columns].each do |c|
        width = c[:width] || 60
        text(c[:title].to_s, width, :font_size => 14, :style => :bold)  
      end      
      line_break(15)
    end
    
    def render_one_column_line(row)
      text(row[@params[:field]], 100, :font_size => 14)
    end
    
    def render_multi_column_line(row)
      @params[:columns].each do |c|
        width = c[:width] || 60
        text(row[c[:name].to_s].to_s, width, :font_size => 14)  
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
