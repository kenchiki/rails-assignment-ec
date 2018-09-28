# frozen_string_literal: true

class ProductPriceCalculation
  def initialize(**args)
    @cart_product = args[:cart_product]
  end

  def calc
    @cart_product.quantity * @cart_product.product_price
  end
end
