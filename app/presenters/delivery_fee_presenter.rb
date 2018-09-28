# frozen_string_literal: true

class DeliveryFeePresenter
  attr_writer :delivery_fee
  attr_reader :params

  def initialize(args)
    @params = args[:params]
    set_path_models
  end

  def delivery_fee
    @delivery_fee.presence || DeliveryFee.new
  end

  def delivery_fees
    DeliveryFee.id_desc
  end

  def began_last_delivery_fee
    DeliveryFee.began_last
  end

  def set_path_models
    @delivery_fee = DeliveryFee.find(params[:id]) if params[:id]
  end
end
