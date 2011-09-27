#coding: utf-8

#gem style
#require 'prawn_report.rb'

#dev style
require File.expand_path(File.dirname(__FILE__) + "/../lib/prawn_report")

require 'yaml'

class PeopleListing < PrawnReport::SimpleListing
  
  
  def initialize(params = {})
    super(params)
    @params = {
      :report_name => 'People Listing', 
      :columns => [
        {:name => 'name', :title => 'Name', :width => 200},
        {:name => 'age', :title => 'Age', :width => 30},
        {:name => 'phone_number', :title => 'Phone #', :width => 100}
      ]
    }
  end
end
