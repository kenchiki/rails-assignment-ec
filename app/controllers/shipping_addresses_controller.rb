# frozen_string_literal: true

class ShippingAddressesController < ApplicationController
  attr_reader :presenter
  before_action :set_presenter

  def new
  end

  def create
    presenter.shipping_address = current_user.shipping_addresses.new(shipping_address_params)
    return render :new unless presenter.shipping_address.save
    redirect_to new_user_shipping_address_path(current_user), notice: t('.success')
  end

  private

  def set_presenter
    @presenter = ShippingAddressPresenter.new(params: params, current_user: current_user)
  end

  def shipping_address_params
    params.require(:shipping_address).permit(:name, :address, :post, :tel)
  end
end
