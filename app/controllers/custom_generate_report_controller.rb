require "custom_report_controller"

class CustomGenerateReportController < ApplicationController

  include PrawnReportController
  
  def get_system_criteria
    {}
  end
  
end
