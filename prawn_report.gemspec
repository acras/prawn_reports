Gem::Specification.new do |s|
  s.name = %q{prawn_report}
  s.version = "1.9.7"
  s.date = %q{2013-03-28}
   s.authors = ["Ricardo Acras" "Egon Hilgenstieler" "Juliano Andrade"]
  s.email = %q{ricardo@acras.com.br julianoch@gmail.com egon@acras.com.br}
  s.summary = %q{Prawn Report makes it easy to create PDF reports.}
  s.homepage = %q{http://www.acras.com.br/}
  s.description = %q{Prawn report is a class repository wich uses prawn gem capabilities to generate PDF documents in order to make it easy to create real life reports.}
  s.files = Dir['lib/**/*.rb'] + Dir['generators/**/*.rb'] + Dir['repo/**/*.rb'] + Dir['app/**/*.rb']
end
