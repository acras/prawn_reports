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
  #      @params = {
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
  #      @params = {
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
    
    def initialize(params = {})
      super(params)
      @header_class = PrawnReport::Header001
      @header_other_pages_class = PrawnReport::Header002       
      @footer_class = PrawnReport::Footer001
      @grouping_info = {:last_group_value => nil, 
                        :groups_runing => false}
    end
    
    protected
    
    def draw_internal
      filling_colors = ['cccccc', 'ffffff'].cycle
      @data['items'].each do |row|
        new_page unless fits?(15)
        run_groups(row) if grouped?
        @x = 0
        @pdf.fill_color filling_colors.next
        @pdf.fill_rectangle [x,y], max_width, 15
        @pdf.fill_color '000000'
        render_line(row)
        line_break(13)
        run_totals(row)
      end
      draw_group_summary if @data['items'].count > 0
    end
    
    def render_line(row)
      if @params[:field]
        render_one_column_line(row)
      elsif @params[:columns]
        render_multi_column_line(row)
      end
    end
    
    def  render_one_column_title
      if @params[:title]
        text(@params[:title], @max_width, :font_size => 12, :style => :bold)
        line_break(13)
      end
    end
    
    def render_multi_column_title
      @params[:columns].each do |c|
        width = c[:width] || 60
        align = c[:align] || :left
        text(c[:title].to_s, width, :font_size => 12, :style => :bold, :align => align)  
      end      
      line_break(13)
    end
    
    def render_one_column_line(row)
      text(row[@params[:field]], 100, :font_size => 12)
    end
    
    def render_multi_column_line(row)
      @params[:columns].each do |c|
        width = c[:width] || 60
        formatter = c[:formatter] || :none
        formatted_text = format(row[c[:name].to_s], formatter)
        align = c[:align] || :left
        font_size = c[:font_size] || 12
        text(formatted_text, width, :font_size => font_size, :align => align)  
      end      
    end
    
    def format(value, formatter)
      if (formatter == :currency)
        return (value.to_i.to_s.reverse.gsub(/...(?=.)/,'\&.').reverse) + ',' + ('%d' % (value * 100 % 100))
      else
        return value.to_s
      end
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
      start_new_group = !@grouping_info[:groups_running]
      start_new_group |=  row[params[:group][:field]] != @grouping_info[:last_group_value]
      if start_new_group
        if (params[:group][:new_page] && 
                     @grouping_info[:groups_running] &&
                     @grouping_info[:last_group_value] != row[params[:group][:field]])
          draw_group_summary
          new_page
        end
        @grouping_info[:last_group_value] = row[params[:group][:field]]
        @grouping_info[:groups_running] = true
        draw_group_header
        draw_column_titles
        reset_group_totals
      end
    end
    
    def draw_column_titles
      if @params[:field]
        render_one_column_title
      elsif @params[:columns]
        render_multi_column_title
      end
    end
    
    def grouped?
      params[:group]
    end
  end
end
