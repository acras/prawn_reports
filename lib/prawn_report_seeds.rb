# coding: utf-8

require 'yaml'


ReportTemplate.delete_all
AcFilterOption.delete_all
AcFilter.delete_all
AcFilterDef.delete_all

puts "Iniciando importação dos filtros"
Dir.glob("#{Rails.root}/db/filters/*.yml").each do |f|
  params = YAML::load(File.open(f, 'r'))
  AcFilterDef.create(params)
  puts "Criado filtro: " + params["name"]
end
puts "FIM"

puts "Iniciando importação dos reports"
Dir.glob("#{Rails.root}/db/reports/*.yml").each do |f|
  puts "Parsing file: #{f}"
  params = YAML::load(File.open(f, 'r'))
  if params["filter_name"]
    f = AcFilterDef.find_by_name(params.delete("filter_name"))
    if f
      params["ac_filter_def_id"] = f.id
    end
  end
  ReportTemplate.create(params)
  puts "Criado relatório: " + params["name"]
end
puts "FIM"

