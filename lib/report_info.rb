# coding: utf-8

require 'date'

module PrawnReport
  class Report
    
    attr_accessor :force_today_as

    def fits?(h)
      (y - footer_size - h - @report_params[:margin][2]) >= 0 
    end
    
    def header_size
      @header ? @header_class.height : 0
    end

    def footer_size
      @footer_class ? @footer_class.height : 0
    end
    
    def today
      @force_today_as ? @force_today_as : Date.today
    end
 
  end
end
