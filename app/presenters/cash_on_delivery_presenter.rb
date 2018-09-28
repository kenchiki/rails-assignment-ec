# frozen_string_literal: true

class CashOnDeliveryPresenter
  attr_writer :cod
  attr_reader :params

  def initialize(args)
    @params = args[:params]
    set_path_models
  end

  def cod
    @cod.presence || CashOnDelivery.new
  end

  def cod_fees
    @cod.cash_on_delivery_fees
  end

  def current_cod
    CashOnDelivery.began_last
  end

  def cods
    CashOnDelivery.with_cod_fees.id_desc
  end

  def set_path_models
    @cod = CashOnDelivery.find(params[:id]) if params[:id]
  end
end
