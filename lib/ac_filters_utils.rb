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
      elsif f.data_type == 'date'
        val = "#{Date.parse(pf['from_date']).strftime('%d/%m/%Y')} até #{Date.parse(pf['to_date']).strftime('%d/%m/%Y')}"        
      elsif f.data_type == 'autocomplete'
        val = Kernel.const_get(f.target_model).find(pf['filter_value']).send(f.target_field)
      end
      r << [f.label, val]
    end
  end
  r
end


module AcFilters
  
  def apply_ac_filter(parsed_filter, system_params)
    system_params.symbolize_keys!
    filter_def = AcFilterDef.find(parsed_filter['filter_def_id'])
    conditions = []
    conditions[0] = ['1=1']
    filter_def.ac_filters.each do |f|
      if f.query_user?
        filled = parsed_filter[f.id]['is_filled'] == 'true'
        if filled && f.has_filled_criteria?
          unless f.data_type == 'checkbox'
            fp = fill_params(f, parsed_filter[f.id])
          end
          conditions[0] << f.filled_criteria
          unless f.data_type == 'checkbox'
            conditions << fp
          end
        elsif !filled && f.has_unfilled_criteria?
          conditions[0] << f.unfilled_criteria
        end
      elsif f.system_criteria.to_s != ''
        conditions[0] << f.filled_criteria
        conditions << system_params[f.system_criteria.to_sym]
      else
        conditions[0] << f.filled_criteria
      end
    end
    
    conditions[0] = conditions[0].join(' and ')
    conditions.flatten!
    
    find_params = {:conditions => conditions}
    
    find_params[:select] = filter_def.select_sql.to_s unless filter_def.select_sql.nil?
    find_params[:order] = filter_def.order_sql.to_s unless filter_def.order_sql.nil?
    find_params[:joins] = filter_def.joins_param unless filter_def.joins_param.nil?  
    find_params[:include] = filter_def.include_param unless filter_def.include_param.nil?
    find_params[:group] = filter_def.group_param unless filter_def.group_param.nil?
    
    find(:all, find_params)
  end
  
  def is_filled?(parsed_params, filter)
    !parsed_params[filter.id].nil?
  end
  
  def fill_params(f, fillings)
    criteria = f.filled_criteria
    if f.data_type == 'date'  
      [fillings['from_date'], fillings['to_date']]
    elsif f.data_type == 'text'
      '%' + fillings['filter_value'] + '%'
    elsif f.data_type == 'options'
      fillings['filter_value']
    else
      fillings['filter_value']
    end
  end
  
end
