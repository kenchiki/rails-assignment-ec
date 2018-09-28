# frozen_string_literal: true

class OrderPresenter
  attr_writer :order
  attr_reader :params

  def initialize(args)
    @params = args[:params]
    @current_user = args[:current_user]
    set_path_models
  end

  def order
    @order.presence || Order.new
  end

  def delivery_times
    delivery_times = DeliveryTime.id_asc
    delivery_times.map do |delivery_time|
      [delivery_time.name, delivery_time.id]
    end
  end

  def delivery_dates
    delivery_dates = DeliveryDateSchedule.new.schedule_dates
    delivery_dates.map do |delivery_date|
      [I18n.l(delivery_date.to_time, format: :date), delivery_date]
    end
  end

  def orders
    @current_user.orders.pager(params)
  end

  def shipping_address_last
    @current_user.shipping_address_last
  end

  def set_path_models
    @order = @current_user.orders.find(params[:id]) if params[:id]
  end
end
