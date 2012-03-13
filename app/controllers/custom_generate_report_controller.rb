require "custom_report_controller"

class CustomGenerateReportController < ApplicationController

  include PrawnReportController
  
  def get_system_criteria
    {}
  end
  
  def get_pr_suggested_filename
    @report_template = ReportTemplate.find(params["report_template_id"])    
    @report_template.report_class.underscore + '_' + Date.today.to_s + '.pdf'
  end
  
  
end
