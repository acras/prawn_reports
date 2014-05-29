class AcFilterSerializer < ActiveModel::Serializer
  attributes :id, :data_type, :label, :target_model, :target_field, :required, :required_from, :required_to
end

