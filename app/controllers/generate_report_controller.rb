require "custom_report_controller"

class GenerateReportController < ApplicationController

  include PrawnReportController
  
  def initialize
    @pr_report_class = ListagemProdutosReport
  end

  def get_pr_report_params; end

  def get_pr_serialization_params
    lab = Laboratorio.find(session[:laboratorio_id])
    {:root_values => {:company_name => lab.nome},
     :include_all_belongs_to => true}
  end

  def get_pr_report_data
    report_template = ReportTemplate.find(params["report_template_id"])
    mc = Kernel.const_get(report_template.ac_filter_def.model_class)
    records = mc.apply_ac_filter(parse_ac_filters(params))
  end

end
