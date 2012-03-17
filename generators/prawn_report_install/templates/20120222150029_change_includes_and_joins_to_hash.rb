class ChangeIncludesAndJoinsToHash < ActiveRecord::Migration
  def self.up
    drop_table :ac_filter_includes
    drop_table :ac_filter_joins
    add_column :ac_filter_defs, :include_param, :text
    add_column :ac_filter_defs, :joins_param, :text
  end

  def self.down
    create_table :ac_filter_includes do |t|
      t.integer :ac_filter_def_id, :name => 'filter_include_in_filter'
      t.string :name
    end
    create_table :ac_filter_joins do |t|
      t.integer :ac_filter_def_id, :name => 'filter_join_in_filter'
      t.string :name
    end
    remove_column :ac_filter_defs, :include_param
    remove_column :ac_filter_defs, :joins_param
  end
end
