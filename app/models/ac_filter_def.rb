class AcFilterDef < ActiveRecord::Base

  has_many :ac_filters, :dependent => :destroy
  accepts_nested_attributes_for :ac_filters

  has_many :report_templates

  def joins_param=(value)
    write_marshal_attribute(:joins_param, value)
  end

  def joins_param
    read_marshal_attribute(:joins_param)
  end

  def include_param=(value)
    write_marshal_attribute(:include_param, value)
  end

  def include_param
    read_marshal_attribute(:include_param)
  end

  def has_sql_query?
    sql_query.to_s != ''
  end

  protected

  def write_marshal_attribute(name, value)
    write_attribute name, Marshal.dump(value)
  end

  def read_marshal_attribute(name)
    value = read_attribute name
    value.nil? ? nil : Marshal.load(value)
  end


end
