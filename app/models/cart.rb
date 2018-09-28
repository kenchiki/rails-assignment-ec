# frozen_string_literal: true

class Cart < ApplicationRecord
  has_many :cart_products, -> { order(id: :desc) }
  has_one :order
  has_many :products, through: :cart_products

  delegate :by_product, to: :cart_products, prefix: true
  delegate :include?, to: :products, prefix: true
  delegate :tax, :cart_total_with_tax, :cart_total, :delivery_fee, :cash_on_delivery_fee,
           :products_total, :products_quantity, to: :cart_price_calculation

  def ordered_at_or_current
    ordered_at.presence || Time.current
  end

  def has_cart_products?
    cart_products.exists?
  end

  private

  def ordered_at
    order&.created_at
  end

  def cart_price_calculation
    @cart_price_calculation ||= CartPriceCalculation.new(
      cart: self
    )
  end
end
