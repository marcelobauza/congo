require "application_system_test_case"

class ProjectInstanceMixesTest < ApplicationSystemTestCase
  setup do
    @project_instance_mix = project_instance_mixes(:one)
  end

  test "visiting the index" do
    visit project_instance_mixes_url
    assert_selector "h1", text: "Project Instance Mixes"
  end

  test "creating a Project instance mix" do
    visit project_instance_mixes_url
    click_on "New Project Instance Mix"

    fill_in "0", with: @project_instance_mix.0
    fill_in "Default", with: @project_instance_mix.DEFAULT
    fill_in "Common expenses", with: @project_instance_mix.common_expenses
    fill_in "Discount", with: @project_instance_mix.discount
    fill_in "H office", with: @project_instance_mix.h_office
    fill_in "Home type", with: @project_instance_mix.home_type
    fill_in "Living room", with: @project_instance_mix.living_room
    fill_in "Mix", with: @project_instance_mix.mix_id
    fill_in "Mix m2 built", with: @project_instance_mix.mix_m2_built
    fill_in "Mix m2 field", with: @project_instance_mix.mix_m2_field
    fill_in "Mix selling speed", with: @project_instance_mix.mix_selling_speed
    fill_in "Mix terrace square meters", with: @project_instance_mix.mix_terrace_square_meters
    fill_in "Mix uf m2", with: @project_instance_mix.mix_uf_m2
    fill_in "Mix uf value", with: @project_instance_mix.mix_uf_value
    fill_in "Mix usable square meters", with: @project_instance_mix.mix_usable_square_meters
    fill_in "Model", with: @project_instance_mix.model
    fill_in "Percentage", with: @project_instance_mix.percentage
    fill_in "Project instance", with: @project_instance_mix.project_instance_id
    fill_in "Service room", with: @project_instance_mix.service_room
    fill_in "Stock units", with: @project_instance_mix.stock_units
    fill_in "T max", with: @project_instance_mix.t_max
    fill_in "T min", with: @project_instance_mix.t_min
    fill_in "Total units", with: @project_instance_mix.total_units
    fill_in "Uf cellar", with: @project_instance_mix.uf_cellar
    fill_in "Uf max", with: @project_instance_mix.uf_max
    fill_in "Uf min", with: @project_instance_mix.uf_min
    fill_in "Uf parking", with: @project_instance_mix.uf_parking
    fill_in "Withdrawal percent", with: @project_instance_mix.withdrawal_percent
    click_on "Create Project instance mix"

    assert_text "Project instance mix was successfully created"
    click_on "Back"
  end

  test "updating a Project instance mix" do
    visit project_instance_mixes_url
    click_on "Edit", match: :first

    fill_in "0", with: @project_instance_mix.0
    fill_in "Default", with: @project_instance_mix.DEFAULT
    fill_in "Common expenses", with: @project_instance_mix.common_expenses
    fill_in "Discount", with: @project_instance_mix.discount
    fill_in "H office", with: @project_instance_mix.h_office
    fill_in "Home type", with: @project_instance_mix.home_type
    fill_in "Living room", with: @project_instance_mix.living_room
    fill_in "Mix", with: @project_instance_mix.mix_id
    fill_in "Mix m2 built", with: @project_instance_mix.mix_m2_built
    fill_in "Mix m2 field", with: @project_instance_mix.mix_m2_field
    fill_in "Mix selling speed", with: @project_instance_mix.mix_selling_speed
    fill_in "Mix terrace square meters", with: @project_instance_mix.mix_terrace_square_meters
    fill_in "Mix uf m2", with: @project_instance_mix.mix_uf_m2
    fill_in "Mix uf value", with: @project_instance_mix.mix_uf_value
    fill_in "Mix usable square meters", with: @project_instance_mix.mix_usable_square_meters
    fill_in "Model", with: @project_instance_mix.model
    fill_in "Percentage", with: @project_instance_mix.percentage
    fill_in "Project instance", with: @project_instance_mix.project_instance_id
    fill_in "Service room", with: @project_instance_mix.service_room
    fill_in "Stock units", with: @project_instance_mix.stock_units
    fill_in "T max", with: @project_instance_mix.t_max
    fill_in "T min", with: @project_instance_mix.t_min
    fill_in "Total units", with: @project_instance_mix.total_units
    fill_in "Uf cellar", with: @project_instance_mix.uf_cellar
    fill_in "Uf max", with: @project_instance_mix.uf_max
    fill_in "Uf min", with: @project_instance_mix.uf_min
    fill_in "Uf parking", with: @project_instance_mix.uf_parking
    fill_in "Withdrawal percent", with: @project_instance_mix.withdrawal_percent
    click_on "Update Project instance mix"

    assert_text "Project instance mix was successfully updated"
    click_on "Back"
  end

  test "destroying a Project instance mix" do
    visit project_instance_mixes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Project instance mix was successfully destroyed"
  end
end
