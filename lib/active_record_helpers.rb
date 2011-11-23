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
    serialize_root_values(@params)

    if @obj.is_a? ActiveRecord::Base
      @contents = serialize_record(@obj, @params)
    elsif @obj.is_a? Array
      @contents += "itens:\n"
      @obj.each do |item|
        indent
        @contents += serialize_record(item, @params)  
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
  
  def serialize_root_values(params)
    params[:root_values] ||= {}
    params[:root_values].each_pair { |k,v| @contents += serialize_key_value(k,v) }
  end
  
  def serialize_record(rec, params = {})
    r = ''
    first_line = true
    rec.attributes.each_pair do |k, v|
      r += render_indent_first_line if first_line
      r += '  ' * @indent_level unless first_line
      r += serialize_key_value(k,v)
      first_line = false
    end
    
    r += serialize_belongs_tos(rec, first_line, params)
    
    r += serialize_has_manys(rec, first_line, params)

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
    r = ''
    if s.lines.count > 1
      r += "|-\n"
      s.lines.each do |l|
        r += '  ' * (@indent_level + 1)
        r += l + "\n"
      end
    else
      r += s + "\n"
    end
    r
  end
  
  def render_indent_first_line
    r = ''
    if @indent_level != 0
      r = '  ' * (@indent_level - 1)
      r += '- '
    end
    r
  end
  
  def render_indent(first_line)
    r = ''
    r += render_indent_first_line(@indent_level) if first_line
    r += '  ' * @indent_level unless first_line
  end
  
  def serialize_belongs_tos(rec, first_line, params)
    r = ''
    params[:included_belongs_to] ||= {}
    params[:included_belongs_to].each_pair do |k,v| 
      serialization_params = v
      type = v[:type] || :fields
      if type == :fields
        v[:fields].each do |f|
          r += render_indent(first_line)
          r += k.to_s + '_' + f.to_s + ': ' + rec.send(k).send(f).to_s + "\n"
          first_line = false
        end
      end
    end
    r
  end

  def serialize_has_manys(rec, first_line, params)
    r = ''
    rec.class.reflect_on_all_associations(:has_many).collect do |hm|
      r += render_indent(first_line)
      r += hm.name.to_s + ":\n"
      rec.send(hm.name).each do |det|
        indent
        r += serialize_record(det, params[:detail_params][hm.name.to_sym] || {})
      end
      first_line = false
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

