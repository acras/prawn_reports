class ReportTemplatesController < ApplicationController

  unloadable

  def index
    conditions = []
    conditions = ['report_type in (?)', parse_array(params['report_type'])] unless params['report_type'].blank?

    @templates = ReportTemplate.find(:all,
      :conditions => conditions)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @templates }
      format.fxml do
        render :fxml => @templates.to_fxml(
        { :include => {
          :ac_filter_def => { :include => {
            :ac_filters => { :include => :ac_filter_options}
            }}
         }
        }
      )
      end
      format.json { render :json => @templates }
    end

  end

  def show
    @report_template = ReportTemplate.find(params[:id])

    respond_to do |format|
      format.json { render :json => @report_template, :root => 'reports' }
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
