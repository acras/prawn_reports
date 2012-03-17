class ChangeSelectSql < ActiveRecord::Migration
  def self.up
    remove_column :ac_filter_defs, :select_sql
    add_column :ac_filter_defs, :select_sql, :text
  end

  def self.down
    remove_column :ac_filter_defs, :select_sql
    add_column :ac_filter_defs, :select_sql, :string
  end
end
