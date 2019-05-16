require "application_system_test_case"

class Admin::CountyUfsTest < ApplicationSystemTestCase
  setup do
    @admin_county_uf = admin_county_ufs(:one)
  end

  test "visiting the index" do
    visit admin_county_ufs_url
    assert_selector "h1", text: "Admin/County Ufs"
  end

  test "creating a County uf" do
    visit admin_county_ufs_url
    click_on "New Admin/County Uf"

    fill_in "County", with: @admin_county_uf.county_id
    fill_in "Property type", with: @admin_county_uf.property_type_id
    fill_in "Uf max", with: @admin_county_uf.uf_max
    fill_in "Uf min", with: @admin_county_uf.uf_min
    click_on "Create County uf"

    assert_text "County uf was successfully created"
    click_on "Back"
  end

  test "updating a County uf" do
    visit admin_county_ufs_url
    click_on "Edit", match: :first

    fill_in "County", with: @admin_county_uf.county_id
    fill_in "Property type", with: @admin_county_uf.property_type_id
    fill_in "Uf max", with: @admin_county_uf.uf_max
    fill_in "Uf min", with: @admin_county_uf.uf_min
    click_on "Update County uf"

    assert_text "County uf was successfully updated"
    click_on "Back"
  end

  test "destroying a County uf" do
    visit admin_county_ufs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "County uf was successfully destroyed"
  end
end
