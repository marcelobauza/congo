require "application_system_test_case"

class CensusTest < ApplicationSystemTestCase
  setup do
    @censu = census(:one)
  end

  test "visiting the index" do
    visit census_url
    assert_selector "h1", text: "Census"
  end

  test "creating a Censu" do
    visit census_url
    click_on "New Censu"

    fill_in "Abc1", with: @censu.abc1
    fill_in "Age 0 9", with: @censu.age_0_9
    fill_in "Age 10 19", with: @censu.age_10_19
    fill_in "Age 20 29", with: @censu.age_20_29
    fill_in "Age 30 39", with: @censu.age_30_39
    fill_in "Age 40 49", with: @censu.age_40_49
    fill_in "Age 50 59", with: @censu.age_50_59
    fill_in "Age 60 69", with: @censu.age_60_69
    fill_in "Age 70 79", with: @censu.age_70_79
    fill_in "Age 80 more", with: @censu.age_80_more
    fill_in "Basic", with: @censu.basic
    fill_in "Block", with: @censu.block
    fill_in "C2", with: @censu.c2
    fill_in "C3", with: @censu.c3
    fill_in "Canceled", with: @censu.canceled
    fill_in "Census source", with: @censu.census_source_id
    fill_in "Cft", with: @censu.cft
    fill_in "Coexist", with: @censu.coexist
    fill_in "County", with: @censu.county_id
    fill_in "D", with: @censu.d
    fill_in "Domestic service", with: @censu.domestic_service
    fill_in "E", with: @censu.e
    fill_in "Education level total", with: @censu.education_level_total
    fill_in "Employee employer", with: @censu.employee_employer
    fill_in "Female", with: @censu.female
    fill_in "Free", with: @censu.free
    fill_in "High school", with: @censu.high_school
    fill_in "Home 1p", with: @censu.home_1p
    fill_in "Home 2p", with: @censu.home_2p
    fill_in "Home 3p", with: @censu.home_3p
    fill_in "Home 4p", with: @censu.home_4p
    fill_in "Home 5p", with: @censu.home_5p
    fill_in "Homes abc1", with: @censu.homes_abc1
    fill_in "Homes c2", with: @censu.homes_c2
    fill_in "Homes c3", with: @censu.homes_c3
    fill_in "Homes d", with: @censu.homes_d
    fill_in "Homes e", with: @censu.homes_e
    fill_in "Homes total", with: @censu.homes_total
    fill_in "Independient", with: @censu.independient
    fill_in "Ip", with: @censu.ip
    fill_in "Labor total", with: @censu.labor_total
    fill_in "Leased", with: @censu.leased
    fill_in "M status total", with: @censu.m_status_total
    fill_in "Male", with: @censu.male
    fill_in "Married", with: @censu.married
    fill_in "Not attended", with: @censu.not_attended
    fill_in "Owner", with: @censu.owner
    fill_in "Population total", with: @censu.population_total
    fill_in "Possession", with: @censu.possession
    fill_in "Predominant", with: @censu.predominant
    fill_in "Salaried", with: @censu.salaried
    fill_in "Separated", with: @censu.separated
    fill_in "Single", with: @censu.single
    fill_in "Socio economic total", with: @censu.socio_economic_total
    fill_in "The geom", with: @censu.the_geom
    fill_in "Transferred", with: @censu.transferred
    fill_in "University", with: @censu.university
    fill_in "Unpaid familiar", with: @censu.unpaid_familiar
    fill_in "Widowed", with: @censu.widowed
    click_on "Create Censu"

    assert_text "Censu was successfully created"
    click_on "Back"
  end

  test "updating a Censu" do
    visit census_url
    click_on "Edit", match: :first

    fill_in "Abc1", with: @censu.abc1
    fill_in "Age 0 9", with: @censu.age_0_9
    fill_in "Age 10 19", with: @censu.age_10_19
    fill_in "Age 20 29", with: @censu.age_20_29
    fill_in "Age 30 39", with: @censu.age_30_39
    fill_in "Age 40 49", with: @censu.age_40_49
    fill_in "Age 50 59", with: @censu.age_50_59
    fill_in "Age 60 69", with: @censu.age_60_69
    fill_in "Age 70 79", with: @censu.age_70_79
    fill_in "Age 80 more", with: @censu.age_80_more
    fill_in "Basic", with: @censu.basic
    fill_in "Block", with: @censu.block
    fill_in "C2", with: @censu.c2
    fill_in "C3", with: @censu.c3
    fill_in "Canceled", with: @censu.canceled
    fill_in "Census source", with: @censu.census_source_id
    fill_in "Cft", with: @censu.cft
    fill_in "Coexist", with: @censu.coexist
    fill_in "County", with: @censu.county_id
    fill_in "D", with: @censu.d
    fill_in "Domestic service", with: @censu.domestic_service
    fill_in "E", with: @censu.e
    fill_in "Education level total", with: @censu.education_level_total
    fill_in "Employee employer", with: @censu.employee_employer
    fill_in "Female", with: @censu.female
    fill_in "Free", with: @censu.free
    fill_in "High school", with: @censu.high_school
    fill_in "Home 1p", with: @censu.home_1p
    fill_in "Home 2p", with: @censu.home_2p
    fill_in "Home 3p", with: @censu.home_3p
    fill_in "Home 4p", with: @censu.home_4p
    fill_in "Home 5p", with: @censu.home_5p
    fill_in "Homes abc1", with: @censu.homes_abc1
    fill_in "Homes c2", with: @censu.homes_c2
    fill_in "Homes c3", with: @censu.homes_c3
    fill_in "Homes d", with: @censu.homes_d
    fill_in "Homes e", with: @censu.homes_e
    fill_in "Homes total", with: @censu.homes_total
    fill_in "Independient", with: @censu.independient
    fill_in "Ip", with: @censu.ip
    fill_in "Labor total", with: @censu.labor_total
    fill_in "Leased", with: @censu.leased
    fill_in "M status total", with: @censu.m_status_total
    fill_in "Male", with: @censu.male
    fill_in "Married", with: @censu.married
    fill_in "Not attended", with: @censu.not_attended
    fill_in "Owner", with: @censu.owner
    fill_in "Population total", with: @censu.population_total
    fill_in "Possession", with: @censu.possession
    fill_in "Predominant", with: @censu.predominant
    fill_in "Salaried", with: @censu.salaried
    fill_in "Separated", with: @censu.separated
    fill_in "Single", with: @censu.single
    fill_in "Socio economic total", with: @censu.socio_economic_total
    fill_in "The geom", with: @censu.the_geom
    fill_in "Transferred", with: @censu.transferred
    fill_in "University", with: @censu.university
    fill_in "Unpaid familiar", with: @censu.unpaid_familiar
    fill_in "Widowed", with: @censu.widowed
    click_on "Update Censu"

    assert_text "Censu was successfully updated"
    click_on "Back"
  end

  test "destroying a Censu" do
    visit census_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Censu was successfully destroyed"
  end
end
