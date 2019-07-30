module SurveyorsHelper
  def surveyors_for_select
    surveyors = Surveyor.select(:id, :name).order(:name)
    surveyors.map {|c| [c.name, c.id]}
  end
end
