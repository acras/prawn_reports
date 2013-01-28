module PrawnReport
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      desc "Copies migrations to app db/migrate folder"
      dirname = File.expand_path('../templates/', __FILE__)
      Dir.glob(File.join(dirname, '*.rb')).each do |mig|
        destfilename = Rails.root.join('db', 'migrate', Pathname.new(mig).basename)
        unless File.exists?(destfilename)
          puts "Imported migration #{Pathname.new(mig).basename}"
          FileUtils.copy(mig, destfilename)
        end
      end

    end
  end
end