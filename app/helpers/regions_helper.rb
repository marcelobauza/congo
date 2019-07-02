module RegionsHelper

  def regions_for_select
    Region.order(:name).map { |region| [region.name, region.id] }
  end   

end
