#coding: utf-8

require File.expand_path(File.dirname(__FILE__) + "/../../../lib/bands/footer_band")

module PrawnReport

  class Footer001 < FooterBand

    def internal_draw
      report.horizontal_line
      report.x = 0
      report.text('Gerado pelo sistema StockFin', report.max_width, 
        :font_size => 10, :align => :left)
    end
    
    def self.height
      10
    end
    
  end
  
end
