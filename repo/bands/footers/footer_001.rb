#coding: utf-8

require File.expand_path(File.dirname(__FILE__) + "/../../../lib/bands/footer_band")

module PrawnReport

  class Footer001 < FooterBand

    def internal_draw
      report.horizontal_line
      report.x = 0
    end
    
    def self.height
      10
    end
    
  end
  
end
