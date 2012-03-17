class PrawnReportInstallGenerator < ::Rails::Generator::Base
  def manifest
    record do |m|
      
    end
  end
  dirname = File.expand_path('../templates/', __FILE__)
  Dir.glob(File.join(dirname, '*.rb')).each do |mig|
    destfilename = Rails.root.join('db', 'migrate', Pathname.new(mig).basename)
    unless File.exists?(destfilename)
      puts "Imported migration #{Pathname.new(mig).basename}"
      FileUtils.copy(mig, destfilename)
    end
  end
  
end

=begin Acho que isso vai ser pro rails 3
require 'rails/generators/migration'

class PrawnReportInstallGenerator < ::Rails::Generators::Base
  include Rails::Generators::Migration
  source_root File.expand_path('./templates', __FILE__)
  desc "Add migrations from Prawn Report"

  def self.next_migration_number(path)
    unless @prev_migration_nr
      @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
    else
      @prev_migration_nr += 1
    end
    @prev_migration_nr.to_s
  end
  def copy_migrations
    migration_template "add_filter_defs.rb", "db/migrate/add_filter_defs.rb"
  end
end
=end
