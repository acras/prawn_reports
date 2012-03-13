class ReportTemplatesController < ApplicationController
  
  def index
    conditions = []
    conditions = ['report_type in (?)', parse_array(params['report_type'])] unless params['report_type'].blank?
    
    @templates = ReportTemplate.find(:all, 
      :conditions => conditions)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @templates }
      format.fxml { render :fxml => @templates.to_fxml({:include => { :ac_filter_def => {}}}) }
    end
    
  end
  
  
  private

  def parse_array(s_array)
    retorno = []
    s_array.split(',').each{|s|
      retorno << s
    }
    retorno
  end
  
  
  
    
end
