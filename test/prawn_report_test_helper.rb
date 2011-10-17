require 'yaml'
require 'tempfile'

class ReportClassTestHelper

  def initialize(klass)
    @klass = klass
    @data = nil
    @initializers = {}
    @params = {}
    @today_is = nil
  end
  
  def with_initializers(initializers)
    @initializers = initializers
    self
  end

  def with_params(params)
    @params = params
    self
  end
  
  def with_yaml(file_path)
    @data = YAML::load(File.open(file_path))
    self
  end
  
  def assuming_today_as(date_str)
    @today_is = Date.parse(date_str)
    self
  end
  
  def should_result_in_pdf(file_path)
    begin
      expected_content = File.open(file_path, 'r').read
      f = Tempfile.new('prawn_report.pdf')
      if @initializers != {}
        r = @klass.new(@initializers)
      else
        r = @klass.new
      end
      if @today_is
        r.force_today_as = @today_is
      end
      r.params.merge!(@params)
      f.write r.draw(@data)
      f.rewind
      actual_content = f.read
      if expected_content.eql? actual_content
        print '.'
        [true, nil]
      else
        ff = File.open(@klass.name + rand(1000000000).to_s + '.pdf', 'w')
        ff.write actual_content
        ff.close
        print 'F'
        [false, [@klass.name, file_path, ff.path]]
      end
    rescue => e
      print 'E'
      return [false, e.to_s + '\n\t' + e.backtrace.join("\n\t")]
    end
  end
  
end


def report_class(klass)
  r = ReportClassTestHelper.new(klass)
end

def test_reports(test_name, &block)
  test_results = []
  puts "Testing #{test_name}"
  yield(test_results)
  puts
  error_count = 0
  test_results.each { |tr| error_count += 1 unless tr[0] }
  puts
  if error_count > 0
    puts "#{test_results.count.to_s} tests, #{error_count.to_s} not passing"
  else
    puts "All tests pass. Go get some coffe!"
  end
  test_results.each do |tr|
    unless tr[0]
      if tr[1].is_a? String
        puts tr[1]
      else
        puts '---'
        puts "Error in class #{tr[1][0]}."
        puts "Expected file: #{tr[1][1]}."
        puts "Resulting file is in #{tr[1][2]}"
      end
    end
  end
end
