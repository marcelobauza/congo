require 'test_helper'

class BotsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bot = bots(:one)
  end

  test "should get index" do
    get bots_url
    assert_response :success
  end

  test "should get new" do
    get new_bot_url
    assert_response :success
  end

  test "should create bot" do
    assert_difference('Bot.count') do
      post bots_url, params: { bot: { apt: @bot.apt, bathroom: @bot.bathroom, bedroom: @bot.bedroom, bimester: @bot.bimester, cellar: @bot.cellar, code: @bot.code, comune: @bot.comune, email: @bot.email, floor: @bot.floor, furnished: @bot.furnished, modality: @bot.modality, number: @bot.number, owner: @bot.owner, parkink_lo: @bot.parkink_lo, phone: @bot.phone, price: @bot.price, price_uf: @bot.price_uf, price_usd: @bot.price_usd, properties: @bot.properties, publish: @bot.publish, region: @bot.region, street: @bot.street, surface: @bot.surface, surface_t: @bot.surface_t, the_geom: @bot.the_geom, type: @bot.type } }
    end

    assert_redirected_to bot_url(Bot.last)
  end

  test "should show bot" do
    get bot_url(@bot)
    assert_response :success
  end

  test "should get edit" do
    get edit_bot_url(@bot)
    assert_response :success
  end

  test "should update bot" do
    patch bot_url(@bot), params: { bot: { apt: @bot.apt, bathroom: @bot.bathroom, bedroom: @bot.bedroom, bimester: @bot.bimester, cellar: @bot.cellar, code: @bot.code, comune: @bot.comune, email: @bot.email, floor: @bot.floor, furnished: @bot.furnished, modality: @bot.modality, number: @bot.number, owner: @bot.owner, parkink_lo: @bot.parkink_lo, phone: @bot.phone, price: @bot.price, price_uf: @bot.price_uf, price_usd: @bot.price_usd, properties: @bot.properties, publish: @bot.publish, region: @bot.region, street: @bot.street, surface: @bot.surface, surface_t: @bot.surface_t, the_geom: @bot.the_geom, type: @bot.type } }
    assert_redirected_to bot_url(@bot)
  end

  test "should destroy bot" do
    assert_difference('Bot.count', -1) do
      delete bot_url(@bot)
    end

    assert_redirected_to bots_url
  end
end
