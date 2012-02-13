class ReportTemplatesController < ApplicationController
  
  def index
    conditions = []
    conditions = ['report_type = ?', params['report_type'].to_s] if params['report_type'].to_s != ''
    @templates = ReportTemplate.find(:all, 
      :conditions => conditions)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @templates }
      format.fxml { render :fxml => @templates.to_fxml({:include => { :ac_filter_def => {}}}) }
    end
    
  end
    
end
