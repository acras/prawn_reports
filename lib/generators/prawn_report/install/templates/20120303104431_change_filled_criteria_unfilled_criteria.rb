class ChangeFilledCriteriaUnfilledCriteria < ActiveRecord::Migration
  def self.up
    remove_column :ac_filters, :filled_criteria
    add_column :ac_filters, :filled_criteria, :text
    remove_column :ac_filters, :unfilled_criteria
    add_column :ac_filters, :unfilled_criteria, :text
  end

  def self.down
    remove_column :ac_filters, :filled_criteria
    add_column :ac_filters, :filled_criteria, :string
    remove_column :ac_filters, :unfilled_criteria
    add_column :ac_filters, :unfilled_criteria, :string
  end
end
