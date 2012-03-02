class AddFiltersToReports < ActiveRecord::Migration
  
  def self.up
    add_column :report_templates, :ac_filter_def_id, :integer, :name => 'filter_in_report_template'
    add_column :report_templates, :report_class, :string
  end

  def self.down
    remove_column :report_templates, :ac_filter_def_id
    remove_column :report_templates, :report_class
  end
  
end
