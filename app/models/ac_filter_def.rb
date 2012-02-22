class AcFilterDef < ActiveRecord::Base
  
  has_many :ac_filters, :dependent => :destroy
  accepts_nested_attributes_for :ac_filters

  has_many :ac_filter_joins, :dependent => :destroy
  accepts_nested_attributes_for :ac_filter_joins
  
  has_many :ac_filter_includes, :dependent => :destroy
  accepts_nested_attributes_for :ac_filter_includes

end
