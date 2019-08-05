require "application_system_test_case"

class UfConversionsTest < ApplicationSystemTestCase
  setup do
    @uf_conversion = uf_conversions(:one)
  end

  test "visiting the index" do
    visit uf_conversions_url
    assert_selector "h1", text: "Uf Conversions"
  end

  test "creating a Uf conversion" do
    visit uf_conversions_url
    click_on "New Uf Conversion"

    fill_in "Uf date", with: @uf_conversion.uf_date
    fill_in "Uf value", with: @uf_conversion.uf_value
    click_on "Create Uf conversion"

    assert_text "Uf conversion was successfully created"
    click_on "Back"
  end

  test "updating a Uf conversion" do
    visit uf_conversions_url
    click_on "Edit", match: :first

    fill_in "Uf date", with: @uf_conversion.uf_date
    fill_in "Uf value", with: @uf_conversion.uf_value
    click_on "Update Uf conversion"

    assert_text "Uf conversion was successfully updated"
    click_on "Back"
  end

  test "destroying a Uf conversion" do
    visit uf_conversions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Uf conversion was successfully destroyed"
  end
end
