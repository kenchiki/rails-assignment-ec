# frozen_string_literal: true

class CartPriceCalculation
  def initialize(**args)
    @cart = args[:cart]
  end

  def cart_total
    products_total + delivery_fee + cash_on_delivery_fee
  end

  def cart_total_with_tax
    cart_total + tax
  end

  def products_total
    # n+1問題対応
    @products_total ||= @cart.cart_products.includes(:cart).includes(:product).sum(&:subtotal_calc)
  end

  def products_quantity
    @products_quantity ||= @cart.cart_products.select(&:quantity).sum(&:quantity)
  end

  def tax
    _tax.calc_tax(cart_total)
  end

  def delivery_fee
    _delivery_fee.calc_deliver_fee(products_quantity)
  end

  def cash_on_delivery_fee
    _cash_on_delivery.cash_on_delivery_fee(products_total)
  end

  private

  def _cash_on_delivery
    CashOnDelivery.began_last_before_time(@cart.ordered_at_or_current)
  end

  def _delivery_fee
    DeliveryFee.began_last_before_time(@cart.ordered_at_or_current)
  end

  def _tax
    Tax.began_last_before_time(@cart.ordered_at_or_current)
  end
end
