class AddFilledCriteriaToOptions < ActiveRecord::Migration
  def self.up
    add_column :ac_filter_options, :filled_criteria, :text
  end

  def self.down
    remove_column :ac_filter_options, :filled_criteria, :text
  end
end
