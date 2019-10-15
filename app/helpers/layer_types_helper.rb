module LayerTypesHelper
  def layer_types_for_select
    LayerType.order(:title).map { |layer_type| [layer_type.title, layer_type.id] }
  end   
end
