#coding: utf-8

#gem style
#require 'prawn_report.rb'

#dev style
require File.expand_path(File.dirname(__FILE__) + "/../lib/prawn_report")
require File.expand_path(File.dirname(__FILE__) + "/../lib/bands/summary_band")
require File.expand_path(File.dirname(__FILE__) + "/../lib/bands/header_band")

require 'yaml'

class MySummary < PrawnReport::SummaryBand

  def internal_draw
    previous_line_width = report.pdf.line_width
    begin
      report.pdf.line_width = 1
      report.horizontal_line(150, 260)
      report.line_break(3)
      report.x = 150
      report.text('Total Inventory: ' + report.group_totals["quantity"].to_s, 110, :style => :bold, :align => :right)
    ensure
      report.pdf.line_width = previous_line_width
    end
  end
  
  def height
    40
  end
  
end

class MyGroupHeader < PrawnReport::HeaderBand

  def internal_draw
    previous_line_width = report.pdf.line_width
    begin
      report.pdf.line_width = 1
      report.text(report.grouping_info[:last_group_value], report.max_width, 
        :style => :italic, :align => :center, :font_size => 16)
      report.line_break(16)
    ensure
      report.pdf.line_width = previous_line_width
    end
  end
  
  def height
    20
  end
  
end

class ProductTypeBreakByGroup < PrawnReport::SimpleListing
  def initialize(params = {})
    params.merge!({:running_totals => ['quantity']})
    super(params)
    @params = {
      :report_name => 'Product types', 
      :columns => [
        {:name => 'name', :title => 'Name', :width => 200},
        {:name => 'quantity', :title => 'Inventory', :width => 60, :align => :right}
      ],
      :group => {:field => 'group', :new_page => true, 
                 :header_class => MyGroupHeader, :summary_class => MySummary}
    }
  end
end
