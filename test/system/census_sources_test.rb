require "application_system_test_case"

class CensusSourcesTest < ApplicationSystemTestCase
  setup do
    @census_source = census_sources(:one)
  end

  test "visiting the index" do
    visit census_sources_url
    assert_selector "h1", text: "Census Sources"
  end

  test "creating a Census source" do
    visit census_sources_url
    click_on "New Census Source"

    fill_in "Name", with: @census_source.name
    click_on "Create Census source"

    assert_text "Census source was successfully created"
    click_on "Back"
  end

  test "updating a Census source" do
    visit census_sources_url
    click_on "Edit", match: :first

    fill_in "Name", with: @census_source.name
    click_on "Update Census source"

    assert_text "Census source was successfully updated"
    click_on "Back"
  end

  test "destroying a Census source" do
    visit census_sources_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Census source was successfully destroyed"
  end
end
