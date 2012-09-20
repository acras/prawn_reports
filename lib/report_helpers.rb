# coding: utf-8

module PrawnReport
  class Report
    include ActionView::Helpers::NumberHelper
      
    def box(width, height, options = {})
      @pdf.rounded_rectangle([0, y], width, height, TEXT_BOX_RADIUS)
    end
      
    def text_box_with_box(label, text, width, height = nil, options = {})
      @pdf.rounded_rectangle([@x, y], width, height || TEXT_BOX_HEIGTH, TEXT_BOX_RADIUS)
      @pdf.text_box(label, :size => LABEL_SIZE, :at => [@x + 2, y - 2], :width => width - 2,
          :height => LABEL_SIZE, :valign => :top)
      h_text = height.nil? ? TEXT_SIZE : height - LABEL_SIZE - 4
      @pdf.text_box(text || '', { :size => TEXT_SIZE, :at => [@x + 2, y - LABEL_SIZE - 4],
          :width => width - 2, :height => h_text, :valign => :top }.merge(options))
      @x += width  
    end
    
    def text(text, width, options = {})
      font_size = options[:font_size] || TEXT_SIZE
      @pdf.text_box(text, :size => font_size, :style => options[:style], :at => [@x, y - 4],
            :width => width, :height => @pdf.height_of(text, :size => font_size), 
            :valign => (options[:valign] || :top),
            :align => (options[:align] || :left)
            )
      @x = @x + width
    end
    
    def horizontal_line(x_ini = 0, x_end = @max_width)
      @pdf.stroke do
        @pdf.horizontal_line(x_ini, x_end, :at => y)
      end
    end
    
    def y
      @pdf.y
    end
    
    def y=(y)
      @pdf.y = y
    end    
    
    def space(width)
      @x += width
    end
    
    def line_break(size = TEXT_SIZE)
      @x = 0
      @pdf.move_down(@pdf.height_of('A', :size => size) + 2)
    end
  
    def format(value, formatter, options = {})
      if !value.nil? && !value.blank?
        if (formatter == :currency)
          number_to_currency(value, :unit => '', :separator => ',', :delimiter => '.')
        elsif (formatter == :date)
          value.strftime('%d/%m/%Y')
        elsif (formatter == :function)
          send(options[:formatter_function].to_s, value)
        else
          value.to_s
        end
      else
        ''
      end
    end	

  end
end
