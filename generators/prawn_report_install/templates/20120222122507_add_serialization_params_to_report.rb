class AddSerializationParamsToReport < ActiveRecord::Migration
  def self.up
    add_column :report_templates, :serialization_params, :text
  end

  def self.down
    remove_column :report_templates, :serialization_params
  end
end
