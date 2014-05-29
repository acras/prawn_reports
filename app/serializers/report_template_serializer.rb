class ReportTemplateSerializer < ActiveModel::Serializer
  embed :ids, :include => true

  attributes :id, :name, :description, :allow_csv

  has_many :filters, :root => 'report_filters'
end

