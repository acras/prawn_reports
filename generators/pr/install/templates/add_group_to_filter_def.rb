class AddGroupToFilterDef < ActiveRecord::Migration
  def self.up
    add_column :ac_filter_defs, :group_param, :string 
  end

  def self.down
    remove_column :ac_filter_defs, :group_param, :string 
  end
end
