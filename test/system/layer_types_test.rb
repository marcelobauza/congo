require "application_system_test_case"

class LayerTypesTest < ApplicationSystemTestCase
  setup do
    @layer_type = layer_types(:one)
  end

  test "visiting the index" do
    visit layer_types_url
    assert_selector "h1", text: "Layer Types"
  end

  test "creating a Layer type" do
    visit layer_types_url
    click_on "New Layer Type"

    fill_in "Name", with: @layer_type.name
    fill_in "Title", with: @layer_type.title
    click_on "Create Layer type"

    assert_text "Layer type was successfully created"
    click_on "Back"
  end

  test "updating a Layer type" do
    visit layer_types_url
    click_on "Edit", match: :first

    fill_in "Name", with: @layer_type.name
    fill_in "Title", with: @layer_type.title
    click_on "Update Layer type"

    assert_text "Layer type was successfully updated"
    click_on "Back"
  end

  test "destroying a Layer type" do
    visit layer_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Layer type was successfully destroyed"
  end
end
