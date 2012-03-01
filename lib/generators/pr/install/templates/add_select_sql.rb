class AddSelectSql < ActiveRecord::Migration
  def self.up
    add_column :ac_filter_defs, :select_sql, :string
  end

  def self.down
    remove_column :ac_filter_defs, :select_sql
  end
end
