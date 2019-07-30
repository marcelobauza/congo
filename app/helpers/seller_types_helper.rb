module SellerTypesHelper

  def seller_types_for_select
    seller_type = SellerType.select(:id, :name).order(:name)
    seller_type.map {|c| [c.name, c.id]}
  end


end
