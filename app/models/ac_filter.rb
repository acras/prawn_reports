class AcFilter < ActiveRecord::Base
  belongs_to :ac_filter_def
  
  has_many :ac_filter_options, :dependent => :destroy
  accepts_nested_attributes_for :ac_filter_options
  
  def has_filled_criteria?
    !self.filled_criteria.nil?
  end
  
  def has_unfilled_criteria?
    !self.unfilled_criteria.nil?
  end
  
end
