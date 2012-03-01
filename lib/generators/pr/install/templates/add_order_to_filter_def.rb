class AddOrderToFilterDef < ActiveRecord::Migration
  def self.up
    add_column :ac_filter_defs, :order_sql, :string
  end

  def self.down
    remove_column :ac_filter_defs, :order_sql
  end
end
