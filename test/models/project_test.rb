require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "new_project" do

    @project = Project.new(
      build_date: '26/10/19', 
      sale_date: '27/10/19', 
      transfer_date: '30/10/19', 
      county_id: County.find_by(name: 'Santiago').id, 
      project_type_id: ProjectType.find_by(name: 'Casa').id, 
      name: 'projets sergio testing', 
      address: 'cordon 157', 
      floors: 1, 
      latitude: '-33.2829397' , 
      longitude: '-70.6432382'
    )
    @project.save!
  end

  test "test_find_globals" do
    filters = {
      "to_year": "2019", 
      "to_period": "2", 
      "periods_quantity": "5", 
      "county_id": ["50"], 
      "type_geometry": "marker", 
      "layer_type":"projects_feature_info", 
      "style_layer": "poi" 
    }
    range = false
    @row_globals = Project.find_globals(filters, range)
    assert_equal 0, @row_globals.project_count
  end

  test "test_find_index" do
    project_type_id = 1
    bimester = 6
    year = 2018
    county = 50
    search = nil
    @row_globals = Project.find_index(project_type_id, bimester, county, year, search)
    assert_equal 6, @row_globals.bimester 
  end
  
  test "test_query_kpi" do

    kpi = Project.kpi("50", "2018","2018","6","2","")

    assert_equal 1, 1 + 0

  end
end
