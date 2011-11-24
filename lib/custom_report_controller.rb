#coding: utf-8

module PrawnReportController
  
  def get_pr_report_data
    []
  end
    
  def get_pr_report_class
    @pr_report_class
  end
    
  def get_pr_suggested_filename
    @pr_suggested_filename || 'relatorio.pdf'
  end
  
  def get_pr_report_params
    @pr_report_params || {}
  end
  
  def get_pr_serialization_params
    @serialization_params || {}
  end
  
  def index
    rec = get_pr_report_data
    report_content = rec.pr_serialize(get_pr_serialization_params)
    report = get_pr_report_class.new(get_pr_report_params)
    
    report_content = report.draw(report_content.get_yaml)

    send_data(report_content, :filename => get_pr_suggested_filename)
  end
  
end 
