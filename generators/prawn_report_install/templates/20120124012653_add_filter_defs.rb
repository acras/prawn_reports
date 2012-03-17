class AddFilterDefs < ActiveRecord::Migration
  def self.up

    create_table :ac_filter_defs do |t|
      t.string :name
      t.text :description
      t.string :model_class
      t.timestamps
    end

    create_table :ac_filters do |t|
      t.integer :ac_filter_def_id, :name => 'filter_def_in_filter'
      t.boolean :query_user
      t.string :data_type
      t.string :label
      t.string :filled_criteria      
      t.string :unfilled_criteria
      t.string :target_model
      t.string :target_field      
    end

    create_table :ac_filter_options do |t|
      t.integer :ac_filter_id, :name => 'filter_in_filter_options'
      t.string :label
      t.string :value
    end
    
  end

  def self.down
    drop_table :ac_filter_options
    drop_table :ac_filters
    drop_table :ac_filter_defs
  end
end
