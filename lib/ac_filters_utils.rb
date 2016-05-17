# encoding: utf-8

def parse_ac_filters(params)
  parsed_filters = {}
  parsed_filters['filter_def_id'] = params['filter_def_id'].to_i
  params.each_pair do |k,v|
    md = /^ac_filter_(\d+)_(.+)/.match(k)
    if md
      filter_id = md[1]
      filter_result_name = md[2].underscore
      filter_value = v
      parsed_filters[filter_id.to_i] = {} unless parsed_filters[filter_id.to_i]
      parsed_filters[filter_id.to_i][filter_result_name] = filter_value
    end
  end
  parsed_filters
end

def get_ac_filters_applied(params, ac_filter_def)
  parsed_filter = parse_ac_filters(params)
  r = []
  ac_filter_def.ac_filters.each do |f|
    if f.query_user? && (parsed_filter[f.id]['is_filled'] == 'true')
      pf = parsed_filter[f.id]
      val = ''
      if ['text', 'options'].include? f.data_type
        val = pf['filter_value']
      elsif ['period', 'timezone_period'].include?(f.data_type)
        if (!pf['from_date'].empty?) && (!pf['to_date'].empty?)
          val = "#{Date.parse(pf['from_date']).strftime('%d/%m/%Y')} até #{Date.parse(pf['to_date']).strftime('%d/%m/%Y')}"
        elsif !pf['from_date'].empty?
          val = "Desde #{Date.parse(pf['from_date']).strftime('%d/%m/%Y')}"
        elsif
          val = "Até #{Date.parse(pf['to_date']).strftime('%d/%m/%Y')}"
        end
      elsif ['autocomplete', 'storecombo'].include?(f.data_type)
        val = Kernel.const_get(f.target_model).find(pf['filter_value']).send(f.target_field)
      end
      r << [f.label, val]
    end
  end
  r
end

def is_filled?(parsed_params, filter)
  !parsed_params[filter.id].nil?
end

def fill_params(f, fillings)
  if ['period', 'timezone_period'].include?(f.data_type)
    [fillings['from_date'], fillings['to_date']]
  elsif f.data_type == 'text'
    '%' + fillings['filter_value'] + '%'
  elsif f.data_type == 'options'
    fillings['filter_value']
  else
    fillings['filter_value']
  end
end

def parse_conditions(parsed_filter, system_params)
  system_params.symbolize_keys!
  filter_def = AcFilterDef.find(parsed_filter['filter_def_id'])
  conditions = []
  conditions[0] = ['1=1']

  filter_def.ac_filters.each do |f|
    if f.query_user?
      parse_condition(conditions, parsed_filter, f)
    elsif f.system_criteria.to_s != ''
      conditions[0] << f.filled_criteria
      conditions << system_params[f.system_criteria.to_sym]
    else
      conditions[0] << f.filled_criteria
    end
  end

  conditions[0] = conditions[0].join(' and ')
  conditions
end

def parse_condition(conditions, parsed_filter, filter)
  filled = parsed_filter[filter.id]['is_filled'] == 'true'

  if filter.data_type == 'checkbox'
    fill_with_checkbox(conditions, filled, parsed_filter, filter)
  elsif filter.data_type == 'options'
    fill_with_options(conditions, filled, parsed_filter, filter)
  elsif filter.data_type == 'period'
    fill_with_period(conditions, filled, parsed_filter, filter)
  elsif filter.data_type == 'timezone_period'
    fill_with_timezone_period(conditions, filled, parsed_filter, filter)
  else
    fill_with_others(conditions, filled, parsed_filter, filter)
  end
end

def fill_with_checkbox(conditions, filled, parsed_filter, filter)
  if filled && filter.has_filled_criteria?
    conditions[0] << filter.filled_criteria
  elsif filter.has_unfilled_criteria?
    conditions[0] << filter.unfilled_criteria
  end
end

def fill_with_options(conditions, filled, parsed_filter, filter)
  if !filled && filter.has_unfilled_criteria?
    conditions[0] << c.unfilled_criteria
  elsif filled
    fo = AcFilterOption.find_by_ac_filter_id_and_value(filter.id, parsed_filter[filter.id]['filter_value'])
    if fo && fo.filled_criteria.to_s != ''
      conditions[0] << fo.filled_criteria
      conditions << fill_params(filter, parsed_filter[filter.id])
    elsif filter.has_filled_criteria?
      conditions[0] << filter.filled_criteria
      conditions << fill_params(filter, parsed_filter[filter.id])
    end
  end
end

def fill_with_period(conditions, filled, parsed_filter, filter)
  if !filled && filter.has_unfilled_criteria?
    conditions[0] << c.unfilled_criteria
  elsif filled
    fp = fill_params(filter, parsed_filter[filter.id])
    if fp[0].to_s != ''
      conditions[0] << filter.filled_criteria_from
      conditions << fp[0]
    end
    if fp[1].to_s != ''
      conditions[0] << filter.filled_criteria_to
      conditions << fp[1]
    end
  end
end

def fill_with_timezone_period(conditions, filled, parsed_filter, filter)
  if !filled && filter.has_unfilled_criteria?
    conditions[0] << c.unfilled_criteria
  elsif filled
    fp = fill_params(filter, parsed_filter[filter.id])
    if fp[0].to_s != ''
      conditions[0] << filter.filled_criteria_from
      conditions << Time.zone.parse(fp[0])
    end
    if fp[1].to_s != ''
      conditions[0] << filter.filled_criteria_to
      conditions << Time.zone.parse(fp[1])+1.day
    end
  end
end

def fill_with_others(conditions, filled, parsed_filter, filter)
  if filled && filter.has_filled_criteria?
    fp = fill_params(filter, parsed_filter[filter.id])
    conditions[0] << filter.filled_criteria
    conditions << fp
  elsif filter.has_unfilled_criteria?
    conditions[0] << filter.unfilled_criteria
  end
end

def get_param_by_label(params, label)
  filter = AcFilter.find(:first, :conditions => ['ac_filter_def_id = ? and label = ?',params['filter_def_id'], label])
  'ac_filter_'+filter.id.to_s
end

module AcFilters
  def apply_ac_filter(parsed_filter, system_params)
    conditions = parse_conditions(parsed_filter, system_params)
    find_params = {:conditions => conditions}
    filter_def = AcFilterDef.find(parsed_filter['filter_def_id'])
    if filter_def.has_sql_query?
      sql_to_execute = ActiveRecord::Base.send(:sanitize_sql_array, conditions)
      r = []
      ActiveRecord::Base.connection.instance_exec(sql_to_execute).each(:as => :hash) {|i| r << i}
    else
      find_params[:select] = filter_def.select_sql.to_s unless filter_def.select_sql.nil?
      find_params[:order] = filter_def.order_sql.to_s unless filter_def.order_sql.nil?
      find_params[:joins] = filter_def.joins_param unless filter_def.joins_param.nil?
      find_params[:include] = filter_def.include_param unless filter_def.include_param.nil?
      find_params[:group] = filter_def.group_param unless filter_def.group_param.nil?
      r = find(:all, find_params)
    end
    r
  end
end
