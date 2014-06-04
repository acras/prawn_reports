class AcFilterOptionSerializer < ActiveModel::Serializer
  embed :ids, :include => true

  attributes :id, :ac_filter_id, :label, :value

end

