# coding: utf-8


module PrawnReport
  mattr_accessor :parent_controller
  @@parent_controller = "CustomGenerateReportController"
end
  
  
require "report"
require "bands/band"
require "bands/summary_band"
require "active_record_helpers"
require "ac_filters_utils"
require File.expand_path(File.dirname(__FILE__) + "/../repo/bands/headers/header_001.rb")
require File.expand_path(File.dirname(__FILE__) + "/../repo/bands/footers/footer_001.rb")
require File.expand_path(File.dirname(__FILE__) + "/../repo/reports/simple_listing.rb")

# Rails 3 compatibility
require 'prawn_report/engine' if ((defined? Rails) and (Rails::version >= '3.0.0'))
