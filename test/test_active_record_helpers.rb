require 'active_record'
require File.dirname(__FILE__) + '/../lib/active_record_helpers'

ActiveRecord::Base.establish_connection(
  :adapter => 'mysql2',
  :encoding => 'utf8',
  :database => 'sgl_web_development',
  :username => 'root',
  :password => '',
  :host => 'localhost'
)


class Store < ActiveRecord::Base
end

class StoreChain < ActiveRecord::Base
  has_many :stores
end


class ActiveRecord::Base
  include PrawnReportActiveRecord
end

class Array
  include PrawnReportActiveRecord  
end


File.open('store.yml', 'w') do |f|
  f.write StoreChain.all.to_report_yaml(:root_values => {:company_name => 'Acras Tecnologia'})
end

