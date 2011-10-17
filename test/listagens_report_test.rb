require File.dirname(__FILE__) + '/prawn_report_test_helper'
require File.dirname(__FILE__) + '/../examples/product_type_break_by_group.rb'
require File.dirname(__FILE__) + '/../examples/simple_listing_people.rb'
require File.dirname(__FILE__) + '/../examples/simple_listing_product_type.rb'

test_reports('Listagens') do |tr|
  tr << report_class(ProductTypeBreakByGroup).
    assuming_today_as('2011-10-17').
    with_yaml(File.dirname(__FILE__) + "/../examples/data/product_types_inventory.yml").
    should_result_in_pdf(File.dirname(__FILE__) + "/../examples/pdfs/product_type_break_by_group.pdf")
  
  tr << report_class(PeopleListing).
    assuming_today_as('2011-10-17').
    with_initializers(:page_size => 'A2').
    with_params(:filters => [['Somente Ativos',''], ['Sexo','Qualquer']]).
    with_yaml(File.dirname(__FILE__) + "/../examples/data/people.yml").
    should_result_in_pdf(File.dirname(__FILE__) + "/../examples/pdfs/simple_listing_people_a2.pdf")
  
  tr << report_class(PeopleListing).
    assuming_today_as('2011-10-17').
    with_initializers(:page_layout => :landscape).
    with_params(:filters => [['Somente Ativos',''], ['Sexo','Qualquer']]).
    with_yaml(File.dirname(__FILE__) + "/../examples/data/people.yml").
    should_result_in_pdf(File.dirname(__FILE__) + "/../examples/pdfs/simple_listing_people_landscape.pdf")
  
  tr << report_class(PeopleListing).
    assuming_today_as('2011-10-17').
    with_initializers(:margin => [50,50,50,50]).
    with_params(:filters => [['Somente Ativos',''], ['Sexo','Qualquer']]).
    with_yaml(File.dirname(__FILE__) + "/../examples/data/people.yml").
    should_result_in_pdf(File.dirname(__FILE__) + "/../examples/pdfs/simple_listing_people_margins.pdf")  
  
  tr << report_class(PeopleListing).
    assuming_today_as('2011-10-17').
    with_params(:filters => [['Somente Ativos',''], ['Sexo','Qualquer']]).
    with_yaml(File.dirname(__FILE__) + "/../examples/data/people.yml").
    should_result_in_pdf(File.dirname(__FILE__) + "/../examples/pdfs/simple_listing_people_with_filters.pdf")  

  tr << report_class(PeopleListing).
    assuming_today_as('2011-10-17').
    with_yaml(File.dirname(__FILE__) + "/../examples/data/people.yml").
    should_result_in_pdf(File.dirname(__FILE__) + "/../examples/pdfs/simple_listing_people_without_filters.pdf")

  tr << report_class(ProductTypeListing).
    assuming_today_as('2011-10-17').
    with_yaml(File.dirname(__FILE__) + "/../examples/data/product_types.yml").
    should_result_in_pdf(File.dirname(__FILE__) + "/../examples/pdfs/product_type_listing.pdf")
   
end
