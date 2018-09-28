# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :cart
  belongs_to :user
  belongs_to :delivery_time

  delegate :products_total, :cash_on_delivery_fee, :delivery_fee,
           :cash_on_delivery_fee, :cart_total, :cart_total_with_tax, :cart_products, to: :cart
  delegate :name, to: :delivery_time, prefix: true
  delegate :shipping_addresses, :email, to: :user, prefix: true
  delegate :name, :address, :post, :tel, to: :shipping_address, prefix: :user

  scope :pager, ->(params) { id_desc.page(params[:page]) }

  validates_with RelationPresenceValidator, relations: %i[cart_products], error: :cart_empty
  validates_with RelationPresenceValidator, relations: %i[user_shipping_addresses], error: :shipping_address_empty
  validates_with DeliveryDateInclusionValidator, field: :delivery_date

  def shipping_address
    user_shipping_addresses.created_last_before_time(created_at)
  end
end
