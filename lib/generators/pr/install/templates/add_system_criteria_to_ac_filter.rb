class AddSystemCriteriaToAcFilter < ActiveRecord::Migration
  def self.up
    add_column :ac_filters, :system_criteria, :string
  end

  def self.down
    remove_column :ac_filters, :system_criteria
  end
end
