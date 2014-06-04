class AcFilterSerializer < ActiveModel::Serializer
  embed :ids, :include => true

  attributes :id, :data_type, :label, :target_model, :target_field, :required, :required_from, :required_to, :query_user

  has_one :ac_filter_def, :root => 'ac_filter_defs'
  has_many :ac_filter_options
end

