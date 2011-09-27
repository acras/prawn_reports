module PrawnReport
  class Report

    def fits?(h)
      (y - footer_size - h - @report_params[:margin][2]) > 0 
    end
    
    def header_size
      @header ? @header_class.height : 0
    end

    def footer_size
      @footer_class ? @footer_class.height : 0
    end
 
  end
end
