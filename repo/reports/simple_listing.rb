#coding: utf-8

require File.expand_path(File.dirname(__FILE__) + "/../../lib/report.rb")
require File.expand_path(File.dirname(__FILE__) + "/../bands/headers/header_001.rb")
require File.expand_path(File.dirname(__FILE__) + "/../bands/headers/header_002.rb")
require File.expand_path(File.dirname(__FILE__) + "/../bands/footers/footer_001.rb")


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


  class SimpleListing < Report

    attr_reader :grouping_info
    alias :super_new_page :new_page
    
    def initialize(report_params = {})
      super(report_params)
      @header_class = PrawnReport::Header001
      @header_other_pages_class = PrawnReport::Header002
      @footer_class = PrawnReport::Footer001
      @grouping_info = {:last_group_value => nil, 
                        :groups_running => false}
      @filling_colors = ['cccccc', 'ffffff'].cycle
      @current_row = nil
      @printing_internal = false
      @data_end = false
    end
    
    #Override line_height to calculate the proper line height for the record
    #The current record can be accessed via the property @current_row
    def line_height
      15
    end
    

    def new_page(print_titles = true)
      super      
      draw_group_header if grouped? and @report_params[:group][:header_reprint_new_page] and !last_group_summary?      
      if print_titles        
        draw_column_titles unless (!draw_group_column_titles? && !@printing_internal) || last_group_summary?
      end
    end

    protected
    
    def draw_internal
      @printing_internal = true
      draw_column_titles unless draw_group_column_titles?
      detail_name = @report_params[:detail_name] || 'items'
      @data_end = false
      @data[detail_name].each do |row|
        @current_row = row
        run_groups(row) if grouped?
        new_page unless fits?(line_height)
        @x = 0
        @pdf.fill_color @filling_colors.next
        @pdf.fill_rectangle [x,y], max_width, line_height
        @pdf.fill_color '000000'
        render_line(row)
        line_break(line_height-4)
        run_totals(row)
      end
      @data_end = true
      draw_group_summary if @data[detail_name].count > 0
      @printing_internal = false
    end
    
    def render_line(row)
      if @report_params[:field]
        render_one_column_line(row)
      elsif @report_params[:columns]
        render_multi_column_line(row)
      end
    end
    
    def  render_one_column_title
      if @report_params[:title]
        text(@report_params[:title], @max_width, :font_size => 12, :style => :bold)
        line_break(13)
      end
    end
    
    def render_multi_column_title
      @report_params[:columns].each do |c|
        width = c[:width] || 60
        align = c[:align] || :left
        text(c[:title].to_s, width, :font_size => c[:font_size] || 12, :style => :bold, :align => align) 
        space(3)
      end      
      line_break(13)
    end
    
    def render_one_column_line(row)
      text(row[@report_params[:field]], 100, :font_size => 12)
    end
    
    def render_multi_column_line(row)
      @report_params[:columns].each do |c|
        width = c[:width] || 60
        formatter = c[:formatter] || :none
        raw_value = get_raw_field_value(row, c[:name].to_s)
        formatter_options = build_formatter_options(formatter, c)
        formatted_text = format(raw_value, formatter, formatter_options)
        align = c[:align] || :left
        font_size = c[:font_size] || 12
        text(formatted_text, width, :font_size => font_size, :align => align)
        space(3)
      end      
    end   
    
    #This function will build the options to be passed to the specific formatter
    def build_formatter_options(formatter, column_def)
      r = {}
      if formatter == :function
        r[:formatter_function] = column_def[:formatter_function]
      end
      r
    end
    def second_pass
      1.upto(@num_pages) do |i|
        @pdf.go_to_page(i)
        @pdf.move_cursor_to(10)
        @x = 0
        text("Página #{@pdf.page_number}/#{@pdf.page_count}", @max_width, :align => :right)
      end
    end
    
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
    
    def draw_column_titles
      new_page(false) unless fits?(30)
      if @report_params[:field]
        render_one_column_title
      elsif @report_params[:columns]
        render_multi_column_title
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

  end
end
