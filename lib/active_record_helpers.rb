#coding: utf-8

require 'yaml'

class ActiveRecordYAMLSerializer

  def initialize(obj, params)
    @obj = obj
    @params = params.symbolize_keys!
    @contents = ''
    @indent_level = 0
  end
  
  def serialize
    @contents = ''
    @contents += serialize_root_values(@params)
    
    if @obj.is_a? ActiveRecord::Base
      @contents += serialize_record(@obj, false, @params) #asnotarray
    elsif @obj.is_a? Array
      @contents += "items:\n"
      @obj.each do |item|
        reset_indent
        indent
        @contents += serialize_record(item, true, @params)  #asarray
      end
    end
    
    
  end
  
  def get_yaml
    YAML::load( @contents )
  end
  
  def save_as(file_name)
    File.open(file_name, 'w') do |f|
      f.write @contents
    end
  end

  private
  
  def indent
    @indent_level += 1
  end
  
  def unindent
    @indent_level -= 1
  end

  def reset_indent(level = 0)
    @indent_level = level
  end
  
  def serialize_root_values(params)
    r = ''
    params[:root_values] ||= {}
    params[:root_values].each_pair { |k,v| r += serialize_key_value(k,v) }
    r
  end
  
  def serialize_record(rec, as_array, params = {})
    r = ''
    first_line = true
    to_serialize = (rec.is_a? ActiveRecord::Base) ? rec.attributes : rec

    to_serialize.each_pair do |k, v|
      r += render_indent_first_line(as_array) if first_line
      r += '  ' * @indent_level unless first_line
      r += serialize_key_value(k,v)
      first_line = false
    end
      
    if rec.is_a? ActiveRecord::Base
      r += serialize_belongs_tos(rec, first_line, params)
      r += serialize_has_manys(rec, first_line, params)
      r += serialize_methods(rec, first_line, params)
    end
    
    r
  end
  
  def serialize_key_value(k, v)
    k.to_s + ': ' + serialize_value(v)
  end
  
  def serialize_value(v)
    if v.is_a? String
      serialize_string(v)
    else
      v.to_s + "\n"
    end
  end
  
  def serialize_string(s)
    s.strip!
    r = ''
    if s.lines.count > 1
      r += "|-\n"
      s.lines.each do |l|
        r += '  ' * (@indent_level + 1)
        r += l.to_s.gsub('\\', '\\\\\\').gsub('"', '\"')
      end
    else
      r += '"' + s.to_s.gsub('\\', '\\\\\\').gsub('"', '\"') + '"'
    end
    r + "\n"
  end
  
  def render_indent_first_line(as_array)
    r = ''
    if @indent_level != 0
      r = '  ' * (@indent_level - 1)
      if (as_array)
        r += '- '
      else
        r += '  '
      end
    end
    r
  end
  
  def render_indent(first_line)
    r = ''
    #r += render_indent_first_line(@indent_level) if first_line
    r += '  ' * @indent_level unless first_line
  end
  
  def serialize_belongs_tos(rec, first_line, params)
    r = ''
    params.symbolize_keys!
    if params[:include_all_belongs_to] == true
      rec.class.reflect_on_all_associations(:belongs_to).collect do |a|
        r += render_indent(first_line)
        r += a.name.to_s + ":\n"
        indent
        r += serialize_record(rec.send(a.name), false, 
          {:include_all_belongs_to => params[:include_all_belongs_to]}) if rec.send(a.name)
        unindent
      end
    else
      params[:included_belongs_to] ||= {}
      params[:included_belongs_to].each_pair do |k,v| 
        v.symbolize_keys!
        serialization_params = v
        type = v[:type].to_sym || :fields
        master_rec = rec.send(k)
        if type == :fields
          v[:fields].each do |f|
            r += render_indent(first_line)
            val = master_rec ? master_rec.send(f) : nil
            r += serialize_key_value(k.to_s + '_' + f.to_s, val)
            first_line = false
          end
        elsif type == :record
          r += render_indent(first_line)
          r += k.to_s + ":\n"
          indent
          r += serialize_record(master_rec, false, v[:params]) if master_rec #as_not_array
          unindent
        end
      end
    end
    r
  end

  def serialize_has_manys(rec, first_line, params)
    r = ''
    params[:included_has_many] ||= {}
    params[:included_has_many].each_pair do |k,v|
      r += render_indent(first_line)
      r += k.to_s + ":"
      r += serialize_has_many(rec.send(k), v)
      first_line = false
    end
    r
  end
  
  def serialize_methods(rec, first_line, params)
    r = ''
    params[:included_methods] ||= {}
    params[:included_methods].each do |v|       
      r += render_indent(first_line)
      val = rec.send(v)
      r += serialize_key_value(v, val)
      first_line = false
    end
    r
  end  
  
  def serialize_has_many(hm, params)
    original_indent = @indent_level
    r = ''
    if hm.count == 0
      r += " []\n"
    else
      r += "\n"
      hm.each do |det|
        reset_indent(original_indent)
        indent
        r += serialize_record(det, true, params || {}) #asarray
      end
    end
    r
  end
  
end

module PrawnReportActiveRecord

  def pr_serialize(params = {})
    a = ActiveRecordYAMLSerializer.new(self, params)
    a.serialize
    a
  end
  
end

