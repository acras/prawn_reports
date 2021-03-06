#coding: utf-8

#gem style
#require 'prawn_report.rb'

#dev style
require File.expand_path(File.dirname(__FILE__) + "/../lib/prawn_report")

require 'yaml'

class ProductTypeListing < PrawnReport::SimpleListing
  def initialize
    super
    @params = {
      :report_name => 'Product Type Listing', 
      :field => 'name',
      :title => 'Name'
    }
  end
end


