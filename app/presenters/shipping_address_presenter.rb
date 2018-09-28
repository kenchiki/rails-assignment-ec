# frozen_string_literal: true

class ShippingAddressPresenter
  attr_writer :shipping_address
  attr_reader :params, :user

  def initialize(args)
    @params = args[:params]
    @current_user = args[:current_user]
    set_path_models
  end

  def shipping_address
    @shipping_address.presence || @current_user.shipping_address_last_or_new
  end

  def set_path_models
    if @current_user
      @user = @current_user
    elsif params[:user_id]
      @user = User.find(params[:user_id])
    end
  end
end
