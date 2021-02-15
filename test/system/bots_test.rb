require "application_system_test_case"

class BotsTest < ApplicationSystemTestCase
  setup do
    @bot = bots(:one)
  end

  test "visiting the index" do
    visit bots_url
    assert_selector "h1", text: "Bots"
  end

  test "creating a Bot" do
    visit bots_url
    click_on "New Bot"

    fill_in "Apt", with: @bot.apt
    fill_in "Bathroom", with: @bot.bathroom
    fill_in "Bedroom", with: @bot.bedroom
    fill_in "Bimester", with: @bot.bimester
    fill_in "Cellar", with: @bot.cellar
    fill_in "Code", with: @bot.code
    fill_in "Comune", with: @bot.comune
    fill_in "Email", with: @bot.email
    fill_in "Floor", with: @bot.floor
    fill_in "Furnished", with: @bot.furnished
    fill_in "Modality", with: @bot.modality
    fill_in "Number", with: @bot.number
    fill_in "Owner", with: @bot.owner
    fill_in "Parkink lo", with: @bot.parkink_lo
    fill_in "Phone", with: @bot.phone
    fill_in "Price", with: @bot.price
    fill_in "Price uf", with: @bot.price_uf
    fill_in "Price usd", with: @bot.price_usd
    fill_in "Properties", with: @bot.properties
    fill_in "Publish", with: @bot.publish
    fill_in "Region", with: @bot.region
    fill_in "Street", with: @bot.street
    fill_in "Surface", with: @bot.surface
    fill_in "Surface t", with: @bot.surface_t
    fill_in "The geom", with: @bot.the_geom
    fill_in "Type", with: @bot.type
    click_on "Create Bot"

    assert_text "Bot was successfully created"
    click_on "Back"
  end

  test "updating a Bot" do
    visit bots_url
    click_on "Edit", match: :first

    fill_in "Apt", with: @bot.apt
    fill_in "Bathroom", with: @bot.bathroom
    fill_in "Bedroom", with: @bot.bedroom
    fill_in "Bimester", with: @bot.bimester
    fill_in "Cellar", with: @bot.cellar
    fill_in "Code", with: @bot.code
    fill_in "Comune", with: @bot.comune
    fill_in "Email", with: @bot.email
    fill_in "Floor", with: @bot.floor
    fill_in "Furnished", with: @bot.furnished
    fill_in "Modality", with: @bot.modality
    fill_in "Number", with: @bot.number
    fill_in "Owner", with: @bot.owner
    fill_in "Parkink lo", with: @bot.parkink_lo
    fill_in "Phone", with: @bot.phone
    fill_in "Price", with: @bot.price
    fill_in "Price uf", with: @bot.price_uf
    fill_in "Price usd", with: @bot.price_usd
    fill_in "Properties", with: @bot.properties
    fill_in "Publish", with: @bot.publish
    fill_in "Region", with: @bot.region
    fill_in "Street", with: @bot.street
    fill_in "Surface", with: @bot.surface
    fill_in "Surface t", with: @bot.surface_t
    fill_in "The geom", with: @bot.the_geom
    fill_in "Type", with: @bot.type
    click_on "Update Bot"

    assert_text "Bot was successfully updated"
    click_on "Back"
  end

  test "destroying a Bot" do
    visit bots_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Bot was successfully destroyed"
  end
end
