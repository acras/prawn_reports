class AddDescriptionToReportTemplate < ActiveRecord::Migration
  def change
    add_column 'report_templates', 'description', :text
    add_column 'report_templates', 'allow_csv', :boolean, :default => false
  end
end
