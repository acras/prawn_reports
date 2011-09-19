#coding: utf-8

require File.expand_path(File.dirname(__FILE__) + "/../../../lib/bands/header_band")

module PrawnReport

  class Header002 < HeaderBand
    
    def internal_draw
      report.x = 0
      report.text(report.data['nome_empresa'], 300, :font_size => 12)
      report.x = 0
      report.text(report.params[:report_name], report.max_width, :font_size => 12, :align => :right)
      report.line_break(12)
      report.horizontal_line
    end
    
    def self.height
      20
    end
    
  end
  
end
