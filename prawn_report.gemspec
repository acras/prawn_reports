Gem::Specification.new do |s|
  s.name = %q{prawn_report}
  s.version = "1.5.29"
  s.date = %q{2012-03-02}
  s.authors = ["Ricardo Acras" "Juliano Andrade" "Egon Hilgenstieler"]
  s.email = %q{ricardo@acras.com.br julianoch@gmail.com egon@acras.com}
  s.summary = %q{Prawn Report makes it easy to create PDF reports.}
  s.homepage = %q{http://www.acras.com.br/}
  s.description = %q{Prawn report is a class repository wich uses prawn gem capabilities to generate PDF documents in order to make it easy to create real life reports.}
  s.files = Dir['lib/**/*.rb'] + Dir['generators/**/*.rb'] + Dir['repo/**/*.rb'] + Dir['app/**/*.rb']
end
