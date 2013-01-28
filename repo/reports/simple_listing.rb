#coding: utf-8

require File.expand_path(File.dirname(__FILE__) + "/listing.rb")

module PrawnReport
  #Generates a listing report with or without multiple columns.
  #
  #==Creating a SimpleListing Report
  #To create a simple listing report you must inherit from PrawnReport::SimpleListing class
  #and fill some parameters. The +report_name+ parameter is mandatory. The other parameters depends
  #if you want a single or multi column listing.
  #
  #The parameters are filled setting the instance variable +params+ hash in initialize after calling
  #super.
  #
  #==Single column listing
  #For single column listings you must fill the +field+ parameter and, optionally, the +title+
  #parameter. Like the code bellow
  #  class ProductTypeListing < PrawnReport::SimpleListing
  #    def initialize
  #      super
  #      @report_params = {
  #        :report_name => 'Product Type Listing', 
  #        :field => 'name',
  #        :title => 'Name'
  #      }
  #    end
  #  end
  #
  #==Multiple column listing
  #To have a multiple column listing you must fill the +columns+ hash inside +params+ hash. Each column
  #has the following properties:
  #* +name+: The name of the field
  #* +title+: The title to be rendered above the first row
  #* +width+: The width of the column. Default value is 60
  #
  #The code belloow shows a listing of people with 3 columns
  #
  #  class PeopleListing < PrawnReport::SimpleListing
  #    def initialize
  #      super
  #      @report_params = {
  #        :report_name => 'People Listing', 
  #        :columns => [
  #          {:name => 'name', :title => 'Name', :width => 200},
  #          {:name => 'age', :title => 'Age', :width => 30},
  #          {:name => 'phone_number', :title => 'Phone #', :width => 100}
  #        ]
  #      }
  #    end
  #  end
  #
  #==Default behaviour
  #The listing bellow shows the default behaviour of this class. This is not changeable at this
  #momment. Any of this behaviour can become changeable in future versions of this gem.
  #
  #* Font: size 12. normal. Times-Roman
  #* Row background color: Alternate between white and gray (cccccc)
  #* First page Header class: PrawnReport::Header001
  #* Other pages Header class: PrawnReport::Header002
  #* Footer class: PrawnReport::Footer001


  class SimpleListing < Listing

    attr_reader :grouping_info
    alias :super_new_page :new_page
    
    def initialize(report_params = {})
      super(report_params)
      @grouping_info = {:last_group_value => nil,
                        :groups_running => false}
    end

    protected

    def run_groups(row)
      group_value = get_raw_field_value(row, params[:group][:field])
      start_new_group = !@grouping_info[:groups_running]
      start_new_group |=  group_value != @grouping_info[:last_group_value]
      if start_new_group
        if(@grouping_info[:groups_running] &&
                     @grouping_info[:last_group_value] != group_value)
          draw_group_summary
          new_page(false) if params[:group][:new_page]
        end
        @grouping_info[:last_group_value] = group_value
        @grouping_info[:groups_running] = true
        draw_group_header
        draw_column_titles if draw_group_column_titles?
        reset_group_totals
      end
    end

    def grouped?
      params[:group]
    end

    def draw_group_column_titles?
      ( params[:group].nil? ? false : (params[:group][:print_group_column_title].nil? ? true :
          params[:group][:print_group_column_title]))
    end

    def last_group_summary?
      @data_end
    end

    def new_page(print_titles = true)
      draw_group_header if grouped? and @report_params[:group][:header_reprint_new_page] and !last_group_summary?
      if print_titles
        draw_column_titles unless (!draw_group_column_titles? && !@printing_internal) || last_group_summary?
      end
    end

    def before_draw_lines
      super
      draw_column_titles unless draw_group_column_titles?
    end

    def after_draw_lines
      draw_group_summary if @data[@detail_name].count > 0
    end

    def before_render_line
      super
      run_groups(row) if grouped?
    end



  end
end
