#coding: utf-8

require File.expand_path(File.dirname(__FILE__) + "/../../../lib/bands/header_band")

module PrawnReport

  #This header renders:
  #
  #* Company name based on a property at the root of data named +company_name+  left aligned
  #  font size 16.
  #* Data de emissão dated today right aligned font size 12
  #* Report name based on a parameter named +report_name+ setted in the report
  class Header001 < HeaderBand
    
    def internal_draw
      report.text(report.data['company_name'], 300, :style => :bold, :font_size => 16)
      txt_emissao = 'Data de emissão: ' + Date.today.strftime('%d/%m/%Y')
      length = report.pdf.width_of(txt_emissao, :size => 12)
      report.x = report.max_width - length
      report.text(txt_emissao, length, :font_size => 12, 
        :valign => :bottom, :align => :right)
      report.line_break(16)
      report.text(report.params[:report_name], report.max_width, :font_size => 13, 
         :align => :center)
      report.line_break(13)
      report.horizontal_line
    end
    
    def self.height
      55
    end
        
  end
  
end
