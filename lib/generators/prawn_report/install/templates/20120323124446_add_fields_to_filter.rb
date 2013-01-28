class AddFieldsToFilter < ActiveRecord::Migration
  def self.up
    add_column :ac_filters, :filled_criteria_from, :text
    add_column :ac_filters, :filled_criteria_to, :text
    add_column :ac_filters, :required, :boolean, :default => false
    add_column :ac_filters, :required_from, :boolean, :default => false
    add_column :ac_filters, :required_to, :boolean, :default => false
  end

  def self.down
    remove_column :ac_filters, :filled_criteria_from
    remove_column :ac_filters, :filled_criteria_to
    remove_column :ac_filters, :required
    remove_column :ac_filters, :required_from
    remove_column :ac_filters, :required_to
  end
end
