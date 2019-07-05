module CountiesHelper

  def counties_for_select
    County.where(enabled: :true).order(:name).map { |county| [county.name, county.id] }
  end   
end
