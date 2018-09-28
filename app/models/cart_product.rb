# frozen_string_literal: true

class CartProduct < ApplicationRecord
  before_create :adjust_quantity

  belongs_to :product
  belongs_to :cart

  MAX_QUANTITY = 20
  attr_accessor :notice

  validates :quantity, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: MAX_QUANTITY }
  validates_with ProductPublishedValidator

  delegate :name, :last_published?, to: :product, prefix: true
  delegate :calc, to: :subtotal, prefix: true
  delegate :order, to: :cart, allow_nil: true
  scope :by_product, ->(product) { where(product_id: product.id) }

  def product_price
    order ? product.ordered_price(order.created_at) : product.last_price
  end

  private

  def adjust_quantity
    summed_quantity = sum_quantity
    if summed_quantity > MAX_QUANTITY
      self.notice = '.adjustment'
      summed_quantity = MAX_QUANTITY
    end
    assign_attributes(quantity: summed_quantity)
  end

  def sum_quantity
    return quantity unless cart.products_include?(product)
    cart_products = cart.cart_products_by_product(product)
    summed_quantity = cart_products.sum(:quantity) + quantity
    cart_products.destroy_all
    raise 'Not sum quantity.' unless cart_products.all?(&:destroyed?)
    summed_quantity
  end

  def subtotal
    @subtotal ||= ProductPriceCalculation.new(cart_product: self)
  end
end
