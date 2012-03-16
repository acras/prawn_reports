class AcFilterDefsController < ApplicationController
  
  unloadable
  
  def index
    @ac_filter_defs = AcFilterDef.find(:all)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ac_filter_defs }
      format.fxml { render :fxml => @ac_filter_defs.to_fxml(
        {:include => {:ac_filters => {:include => { :ac_filter_options => {}}}}} )}
    end
    
  end
  
end
