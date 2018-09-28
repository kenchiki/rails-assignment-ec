# frozen_string_literal: true

module Admin
  class ProductPresenter
    attr_writer :product
    attr_reader :params

    def initialize(args)
      @params = args[:params]
      set_path_models
    end

    def product
      @product.presence || Product.new
    end

    def products
      Product.pager(params)
    end

    def set_path_models
      @product = Product.find(params[:id]) if params[:id]
    end
  end
end
