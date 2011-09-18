#coding: utf-8

require File.expand_path(File.dirname(__FILE__) + "/header_band")

module PrawnReport

  class Header001 < HeaderBand
    
    def internal_draw
      report.text('Nome da empresa', 300, :style => :bold, :font_size => 16)
      txt_emissao = 'Data de emissão: ' + Date.today.strftime('%d/%m/%Y')
      length = report.pdf.width_of(txt_emissao, :size => 12)
      report.x = report.max_width - length
      report.text(txt_emissao, length, :font_size => 12, 
        :valign => :bottom, :align => :right)
      report.line_break(16)
      report.text('Report Name', report.max_width, :font_size => 10, 
         :align => :center)
      report.line_break(11)
      report.horizontal_line
    end
    
    def self.height
      50
    end
        
  end
  
end
