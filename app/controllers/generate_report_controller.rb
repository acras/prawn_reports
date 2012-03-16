class GenerateReportController < PrawnReport.parent_controller.constantize
  
  unloadable

  def get_pr_report_class
    @report_template = ReportTemplate.find(params["report_template_id"])    
    Kernel.const_get(@report_template.report_class)
  end  

  def get_pr_report_params; end

  def get_pr_report_data
    @report_template = ReportTemplate.find(params["report_template_id"])
    mc = Kernel.const_get(@report_template.ac_filter_def.model_class)
    mc.apply_ac_filter(parse_ac_filters(params), get_system_criteria)
  end
  
  def get_pr_filters
    @report_template = ReportTemplate.find(params["report_template_id"])
    get_ac_filters_applied(params, @report_template.ac_filter_def)
  end

end
