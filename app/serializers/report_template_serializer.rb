class ReportTemplateSerializer < ActiveModel::Serializer
  embed :ids, :include => true

  attributes :id, :name, :description, :allow_csv, :ac_filter_def_id, :controller_name, :report_type

  has_one :ac_filter_def, :root => 'ac_filter_defs'

end

