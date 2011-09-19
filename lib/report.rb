#coding: utf-8

require 'prawn'

require File.expand_path(File.dirname(__FILE__) + "/report_helpers")
require File.expand_path(File.dirname(__FILE__) + "/report_info")

# This is the module for all classes in the prawn_report gem
module PrawnReport

  #Will be passed to pdf constructor, default page size is A4
  PAGE_SIZE = 'A4'
  DEFAULT_PAGE_LAYOUT = :portrait
  MARGIN = [20, 20, 20, 20] # [top, right, bottom, left]
  
  LABEL_SIZE = 6
  TEXT_SIZE = 10
  
  SECTION_SPACING = LABEL_SIZE + 4
  
  LINE_WIDTH = 0.3
  
  DEFAULT_FONT = 'Times-Roman'
    
  TEXT_BOX_RADIUS = 2
  TEXT_BOX_HEIGTH = 20
  
  # Report is the base class for all reports, it encapsulates all logic for rendering
  #   report parts.
  class Report
    attr_reader :pdf, :data, :max_width, :max_height
    attr_accessor :header_class, :header_other_pages_class, :x, :params
    
    def initialize
      @num_pages = 1
      
      @pdf = Prawn::Document.new(:page_size => PAGE_SIZE, :margin => MARGIN,
            :page_layout => DEFAULT_PAGE_LAYOUT)
        
      @pdf.font(DEFAULT_FONT)
      @pdf.line_width = LINE_WIDTH
      @pdf.move_cursor_to(50 - MARGIN[2])
      
      w, h = *Prawn::Document::PageGeometry::SIZES[PAGE_SIZE]
      @x = 0
      @y = @max_height = h - (MARGIN[0] + MARGIN[2])
      @max_width = w - (MARGIN[1] + MARGIN[3])

      @footer_size = 0
      @pdf.move_cursor_to(max_height - MARGIN[2])
      
      @header_class = nil
      @header_other_pages_class = nil
    end
    
    def draw(data)
      @data = data
      
      draw_header_first_page
      draw_internal
      draw_footer
      
      second_pass
      
      @pdf.close_and_stroke
      @pdf.render
    end
    
    def new_page
      draw_footer
      
      @num_pages += 1
      @pdf.start_new_page
      @x = 0
      @pdf.move_down(MARGIN[0])
      
      draw_header_other_pages
    end
    
    protected
    
    def draw_header_first_page
      draw_header(@header_class)
    end  
      
    def draw_header_other_pages
      draw_header(@header_other_pages_class || @header_class)
    end
    
    def draw_header(klass)
      if klass
        header = klass.new(self)
        header.draw
        @pdf.y = @max_height - klass.height
        @x = 0
      end
    end
    
    def draw_footer
      if @footer_class
        footer = @footer_class.new(self)
        @pdf.move_cursor_to(@footer_class.height)
        footer.draw
      end
    end      

    def second_pass
    
    end
          
  end
end  

