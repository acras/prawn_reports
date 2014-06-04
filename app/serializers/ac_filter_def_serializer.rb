class AcFilterDefSerializer < ActiveModel::Serializer
  embed :ids, :include => true

  attributes :id, :name

  has_many :report_templates, :root => 'report_templates'
  has_many :ac_filters, :root => 'ac_filters'

end

