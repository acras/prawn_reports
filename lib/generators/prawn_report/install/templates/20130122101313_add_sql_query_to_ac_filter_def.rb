class AddSqlQueryToAcFilterDef < ActiveRecord::Migration
  def change
    add_column 'ac_filter_defs', 'sql_query', :text
  end
end
