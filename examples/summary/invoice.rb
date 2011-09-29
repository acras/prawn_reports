#coding: utf-8

#gem style
#require 'prawn_report.rb'

#dev style
require File.expand_path(File.dirname(__FILE__) + "/../../lib/prawn_report")
require File.expand_path(File.dirname(__FILE__) + "/../../lib/bands/summary_band")

require 'yaml'

class InvoiceSummary < PrawnReport::SummaryBand

  def internal_draw
    previous_line_width = report.pdf.line_width
    begin
      report.pdf.line_width = 1
      report.horizontal_line(150, 260)
      report.line_break(3)
      report.x = 150
      report.text('Totais', 40, :style => :bold, :align => :right)
      report.x = 200
      report.text(report.data['total_quantity'].to_s, 30, :font_size => 12)
      report.text(report.data['total_price'].to_s, 30, :font_size => 12)
    ensure
      report.pdf.line_width = previous_line_width
    end
  end
  
  def height
    40
  end
  
end

class InvoiceReport < PrawnReport::SimpleListing
  
  def initialize(params = {})
    super(params)
    @summary_class = InvoiceSummary
    @params = {
      :report_name => 'Invoice', 
      :columns => [
        {:name => 'product', :title => 'Product', :width => 200},
        {:name => 'quantity', :title => 'Qty.', :width => 30},
        {:name => 'unit_price', :title => 'Un. Price', :width => 30}
      ]
    }
  end
  
end

data = YAML::load( File.open( File.expand_path(File.dirname(__FILE__) + "/../data/invoice.yml") ) )
f = InvoiceReport.new
puts f.draw(data)
