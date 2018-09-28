# frozen_string_literal: true

module CartProductsHelper
  def quantity_range
    1..CartProduct::MAX_QUANTITY
  end
end
