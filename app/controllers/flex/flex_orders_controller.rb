class Flex::FlexOrdersController < ApplicationController

  def new
    @flex_order = FlexOrder.new
  end

  def create
    require 'mercadopago'
    @flex_order = FlexOrder.new(flex_order_params)
    sdk = Mercadopago::SDK.new('TEST-729515335620012-100805-7bb9e3341850d273e54eea3c30bdb0b0-837736362')
    preference_data = {
      items: [
        {
          title: 'Reporte Flex',
          quantity: @flex_order.amount,
          currency_id: 'CLP',
          unit_price: 3000
        }
      ],
      binary_mode: true,
      back_urls: {
        success: 'http://app.inciti.com/es/flex/',
        failure: 'http://app.inciti.com/es/flex/',
        pending: 'http://app.inciti.com/es/flex/'
      },
      auto_return: 'approved'
    }
    preference_response = sdk.preference.create(preference_data)
    preference = preference_response[:response]
    @preference_id = preference['id']
  end
  private

  def flex_order_params
    params.require(:flex_order).permit(:amount, :status).merge(user_id: current_user.id)
  end
