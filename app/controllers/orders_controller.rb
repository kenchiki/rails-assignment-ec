# frozen_string_literal: true

class OrdersController < ApplicationController
  attr_reader :presenter
  before_action :set_presenter

  def index
  end

  def show
  end

  def new
  end

  def create
    return render :new unless create_order
    deliver_ordered_mail(presenter.order)
    new_cart
    redirect_to presenter.order, notice: t('.success')
  end

  private

  def create_order
    presenter.order = Order.new(order_params)
    presenter.order.cart = current_cart
    presenter.order.user = current_user
    presenter.order.save
  end

  def deliver_ordered_mail(order)
    OrderMailer.user_thanks(order: order)
    OrderMailer.notify_admin(order: order)
  end

  def set_presenter
    @presenter = OrderPresenter.new(params: params, current_user: current_user)
  end

  def order_params
    params.require(:order).permit(:delivery_date, :delivery_time_id)
  end
end
