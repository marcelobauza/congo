require 'test_helper'

class CensusControllerTest < ActionDispatch::IntegrationTest
  setup do
    @censu = census(:one)
  end

  test "should get index" do
    get census_url
    assert_response :success
  end

  test "should get new" do
    get new_censu_url
    assert_response :success
  end

  test "should create censu" do
    assert_difference('Censu.count') do
      post census_url, params: { censu: { abc1: @censu.abc1, age_0_9: @censu.age_0_9, age_10_19: @censu.age_10_19, age_20_29: @censu.age_20_29, age_30_39: @censu.age_30_39, age_40_49: @censu.age_40_49, age_50_59: @censu.age_50_59, age_60_69: @censu.age_60_69, age_70_79: @censu.age_70_79, age_80_more: @censu.age_80_more, basic: @censu.basic, block: @censu.block, c2: @censu.c2, c3: @censu.c3, canceled: @censu.canceled, census_source_id: @censu.census_source_id, cft: @censu.cft, coexist: @censu.coexist, county_id: @censu.county_id, d: @censu.d, domestic_service: @censu.domestic_service, e: @censu.e, education_level_total: @censu.education_level_total, employee_employer: @censu.employee_employer, female: @censu.female, free: @censu.free, high_school: @censu.high_school, home_1p: @censu.home_1p, home_2p: @censu.home_2p, home_3p: @censu.home_3p, home_4p: @censu.home_4p, home_5p: @censu.home_5p, homes_abc1: @censu.homes_abc1, homes_c2: @censu.homes_c2, homes_c3: @censu.homes_c3, homes_d: @censu.homes_d, homes_e: @censu.homes_e, homes_total: @censu.homes_total, independient: @censu.independient, ip: @censu.ip, labor_total: @censu.labor_total, leased: @censu.leased, m_status_total: @censu.m_status_total, male: @censu.male, married: @censu.married, not_attended: @censu.not_attended, owner: @censu.owner, population_total: @censu.population_total, possession: @censu.possession, predominant: @censu.predominant, salaried: @censu.salaried, separated: @censu.separated, single: @censu.single, socio_economic_total: @censu.socio_economic_total, the_geom: @censu.the_geom, transferred: @censu.transferred, university: @censu.university, unpaid_familiar: @censu.unpaid_familiar, widowed: @censu.widowed } }
    end

    assert_redirected_to censu_url(Censu.last)
  end

  test "should show censu" do
    get censu_url(@censu)
    assert_response :success
  end

  test "should get edit" do
    get edit_censu_url(@censu)
    assert_response :success
  end

  test "should update censu" do
    patch censu_url(@censu), params: { censu: { abc1: @censu.abc1, age_0_9: @censu.age_0_9, age_10_19: @censu.age_10_19, age_20_29: @censu.age_20_29, age_30_39: @censu.age_30_39, age_40_49: @censu.age_40_49, age_50_59: @censu.age_50_59, age_60_69: @censu.age_60_69, age_70_79: @censu.age_70_79, age_80_more: @censu.age_80_more, basic: @censu.basic, block: @censu.block, c2: @censu.c2, c3: @censu.c3, canceled: @censu.canceled, census_source_id: @censu.census_source_id, cft: @censu.cft, coexist: @censu.coexist, county_id: @censu.county_id, d: @censu.d, domestic_service: @censu.domestic_service, e: @censu.e, education_level_total: @censu.education_level_total, employee_employer: @censu.employee_employer, female: @censu.female, free: @censu.free, high_school: @censu.high_school, home_1p: @censu.home_1p, home_2p: @censu.home_2p, home_3p: @censu.home_3p, home_4p: @censu.home_4p, home_5p: @censu.home_5p, homes_abc1: @censu.homes_abc1, homes_c2: @censu.homes_c2, homes_c3: @censu.homes_c3, homes_d: @censu.homes_d, homes_e: @censu.homes_e, homes_total: @censu.homes_total, independient: @censu.independient, ip: @censu.ip, labor_total: @censu.labor_total, leased: @censu.leased, m_status_total: @censu.m_status_total, male: @censu.male, married: @censu.married, not_attended: @censu.not_attended, owner: @censu.owner, population_total: @censu.population_total, possession: @censu.possession, predominant: @censu.predominant, salaried: @censu.salaried, separated: @censu.separated, single: @censu.single, socio_economic_total: @censu.socio_economic_total, the_geom: @censu.the_geom, transferred: @censu.transferred, university: @censu.university, unpaid_familiar: @censu.unpaid_familiar, widowed: @censu.widowed } }
    assert_redirected_to censu_url(@censu)
  end

  test "should destroy censu" do
    assert_difference('Censu.count', -1) do
      delete censu_url(@censu)
    end

    assert_redirected_to census_url
  end
end
