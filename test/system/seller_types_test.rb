require "application_system_test_case"

class SellerTypesTest < ApplicationSystemTestCase
  setup do
    @seller_type = seller_types(:one)
  end

  test "visiting the index" do
    visit seller_types_url
    assert_selector "h1", text: "Seller Types"
  end

  test "creating a Seller type" do
    visit seller_types_url
    click_on "New Seller Type"

    fill_in "Name", with: @seller_type.name
    click_on "Create Seller type"

    assert_text "Seller type was successfully created"
    click_on "Back"
  end

  test "updating a Seller type" do
    visit seller_types_url
    click_on "Edit", match: :first

    fill_in "Name", with: @seller_type.name
    click_on "Update Seller type"

    assert_text "Seller type was successfully updated"
    click_on "Back"
  end

  test "destroying a Seller type" do
    visit seller_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Seller type was successfully destroyed"
  end
end
