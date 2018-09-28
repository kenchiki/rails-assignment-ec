# frozen_string_literal: true

class ProductPresenter
  attr_reader :params

  def initialize(args)
    @params = args[:params]
  end

  def published_products
    Product.published.pager(params)
  end
end
