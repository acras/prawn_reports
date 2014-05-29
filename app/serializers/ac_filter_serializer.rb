class AcFilterSerializer < ActiveModel::Serializer
  attributes :id, :data_type, :label, :target_model, :target_field, :required, :required_from, :required_to, :report_id

  #Assumes that there is only one report to one ac_filter_def
  def report_id
    object.ac_filter_def.report_templates.first.try(:id)
  end

end

