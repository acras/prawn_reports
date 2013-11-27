module PrawnReport
  class NoGroupingFieldProvided < Exception; end
  class NoGroupingValueFieldProvided < Exception; end
  class NoGroupingContextFieldProvided < Exception; end

  class ColumnGroup < Listing
    attr_accessor :grouping_field
    attr_accessor :grouping_context_field
    attr_accessor :grouping_value_field

    def new_page(print_titles = true)
      draw_column_titles if print_titles
    end

    def before_draw_lines
      super
      draw_column_titles
    end

    def initialize(report_params = {})
      super(report_params)
      raise NoGroupingFieldProvided unless report_params[:grouping_field]
      raise NoGroupingValueFieldProvided unless report_params[:grouping_value_field]
      raise NoGroupingContextFieldProvided unless report_params[:grouping_context_field]
      @grouping_field = report_params[:grouping_field]
      @grouping_value_field = report_params[:grouping_value_field]
      @grouping_context_field = report_params[:grouping_context_field]
    end

    def before_draw
      @data = traverse_data(@data)
    end

    protected

    def traverse_data(data)
      new_data = []
      last_value = nil
      new_row = nil
      old_data = data[@detail_name]
      old_data.each do |row|
        if row[@grouping_field] != last_value then
          new_data << new_row unless new_row.nil?
          last_value = row[@grouping_field]
          new_row = {}
          row.each_pair {|k,v| new_row[k] = v}
        end
        new_row[@grouping_context_field.to_s + '_' + row[@grouping_context_field].to_s] = row[@grouping_value_field]
      end
      new_data << new_row unless new_row.nil?
      data[@detail_name]=new_data
      data
    end


  end
end
