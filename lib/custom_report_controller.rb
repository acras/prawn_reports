#coding: utf-8

module PrawnReportController

  def get_pr_report_data
    []
  end

  def get_pr_report_class
    @pr_report_class
  end

  def get_pr_suggested_filename; end
  def fill_report_params; end

  def get_pr_report_params
    @pr_report_params || {}
  end

  def get_pr_serialization_params
    @serialization_params || {}
  end

  def get_pr_filters
    @filters
  end

  def index
    @filters = []
    rec = get_pr_report_data
    if rec.nil? || (rec.is_a?(Array) && rec.count == 0)
      cookies[:fileDownload] = true
      render :nothing => true, :status => :no_content
    else
      report_content = rec.pr_serialize(get_pr_serialization_params)
      report = get_pr_report_class.new(get_pr_report_params)
      report.report_params[:filters] = get_pr_filters
      report.report_params[:filter_params]  = parse_ac_filters(params)
      fill_report_params(report)

      fn = get_pr_suggested_filename

      respond_to do |format|
        cookies[:fileDownload] = true
        format.pdf do
          report_content = report.draw(report_content.get_yaml)
          if fn
            send_data(report_content, :filename => "#{fn}.pdf")
          else
            send_data(report_content, :disposition => 'inline', :type => 'application/pdf')
          end
        end
        format.csv do
          report_content = report.draw_csv(report_content.get_yaml)
          fn ||= "report"
          send_data(report_content, :filename => "#{fn}.csv")
        end
      end

    end
  end

end
