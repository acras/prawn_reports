class ReportTemplate < ActiveRecord::Base
  belongs_to :ac_filter_def
  
  def serialization_params=(value)
    if value.is_a? Hash
      value = Marshal.dump(value)
    end
    write_attribute :serialization_params, value
  end
  
  def serialization_params
    value = read_attribute :serialization_params
    value.nil? ? {} : Marshal.load(value)
  end
  
end
