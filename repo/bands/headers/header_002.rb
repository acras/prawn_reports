#coding: utf-8

require File.expand_path(File.dirname(__FILE__) + "/../../../lib/bands/header_band")

module PrawnReport
  #This is a minimalist header intended to render the company name and report name in additional
  #pages of a report.
  #
  #This header renders:
  #
  #* Company name based on a property at the root of data named +company_name+  left aligned
  #  font size 12.
  #* Report name based on a parameter named +report_name+ setted in the report
  class Header002 < HeaderBand
    
    def internal_draw
      report.x = 0
      report.text(report.data['company_name'], 300, :font_size => 12)
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
