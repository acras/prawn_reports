#coding: utf-8

require File.expand_path(File.dirname(__FILE__) + "/../../lib/report.rb")
require File.expand_path(File.dirname(__FILE__) + "/../bands/headers/header_001.rb")
require File.expand_path(File.dirname(__FILE__) + "/../bands/headers/header_002.rb")
require File.expand_path(File.dirname(__FILE__) + "/../bands/footers/footer_001.rb")

module PrawnReport
  class Listing < Report

    #alias :super_new_page :new_page

    def initialize(report_params = {})
      super(report_params)
      @header_class = PrawnReport::Header001
      @header_other_pages_class = PrawnReport::Header002
      @footer_class = PrawnReport::Footer001
      @filling_colors = ['cccccc', 'ffffff'].cycle
      @current_row = nil
      @printing_internal = false
      @data_end = false
      @detail_name = @report_params[:detail_name] || 'items'
    end

    #Override line_height to calculate the proper line height for the record
    #The current record can be accessed via the property @current_row
    def line_height
      15
    end

    def before_draw_lines
      @printing_internal = true
      @data_end = false
    end

    def after_draw_lines
      @data_end = true
      @printing_internal = false
    end

    def before_render_line
      new_page unless fits?(line_height)
      @x = 0
      @pdf.fill_color @filling_colors.next
      @pdf.fill_rectangle [x,y], max_width, line_height
      @pdf.fill_color '000000'
    end

    def after_render_line
      line_break(line_height-4)
      run_totals(@current_row)
    end

    def draw_lines
      @data[@detail_name].each do |row|
        @current_row = row
        before_render_line
        render_line(@current_row)
        after_render_line
      end
    end

    def draw_internal
      before_draw_lines if defined? before_draw_lines
      draw_lines if defined? 'draw_lines'
      after_draw_lines if defined? after_draw_lines
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
        unless c[:formatter] == :invisible
          width = c[:width] || 60
          align = c[:align] || :left
          text(c[:title].to_s, width, :font_size => c[:font_size] || 12, :style => :bold, :align => align)
          space(3)
        end
      end
      line_break(13)
    end

    def render_one_column_line(row)
      text(row[@report_params[:field]], 100, :font_size => 12)
    end

    def render_multi_column_line(row)
      @report_params[:columns].each do |c|
        unless c[:formatter] == :invisible
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

    def draw_column_titles
      new_page(false) unless fits?(30)
      if @report_params[:field]
        render_one_column_title
      elsif @report_params[:columns]
        render_multi_column_title
      end
    end
  end
end