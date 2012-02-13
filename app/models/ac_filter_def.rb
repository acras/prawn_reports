class AcFilterDef < ActiveRecord::Base
  
  has_many :ac_filters, :dependent => :destroy
  accepts_nested_attributes_for :ac_filters
  
end
