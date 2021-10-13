class Flex::FlexOrdersController < ApplicationController

  def new
    @flex_order = FlexOrder.new
  end

  def create
    require 'mercadopago'
    @flex_order = FlexOrder.new(flex_order_params)
    sdk = Mercadopago::SDK.new('TEST-729515335620012-100805-7bb9e3341850d273e54eea3c30bdb0b0-837736362')
    @unit_price = 5000
    preference_data = {
      items: [
        {
          title: 'Reporte Flex',
          quantity: @flex_order.amount,
          currency_id: 'CLP',
          unit_price: @unit_price
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
    respond_to do |format|
      if @flex_order.save
        format.js
        format.html { redirect_to @flex_report, notice: 'La orden se creó correctamente.' }
        format.json { render :show, status: :created, location: @flex_order }
      else
        format.js
        format.html { render :new }
        format.json { render json: @flex_order.errors, status: :unprocessable_entity }
      end
    end

  end

  private

  def flex_order_params
    params.require(:flex_order).permit(:amount, :status).merge(user_id: current_user.id)
  end

end
