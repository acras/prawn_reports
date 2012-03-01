class CreateAcFilterJoins < ActiveRecord::Migration
  def self.up
    create_table :ac_filter_joins do |t|
      t.integer :ac_filter_def_id, :name => 'filter_join_in_filter'
      t.string :name
    end
  end

  def self.down
    drop_table :ac_filter_joins
  end
end
