class CreatePrawnReportCatalogs < ActiveRecord::Migration
  def self.up
    create_table :report_templates do |t|
      t.string :name
      t.string :report_type
      t.string :controller_name
      t.timestamps
    end  
  end

  def self.down
    drop_table :report_templates
  end
end
