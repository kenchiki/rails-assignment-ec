# frozen_string_literal: true

class CartProductPresenter
  attr_writer :cart_product
  attr_reader :params, :product, :cart

  def initialize(args)
    @params = args[:params]
    @cart = args[:cart]
    set_path_models
  end

  def cart_product
    @cart_product.presence || @cart.cart_products.new
  end

  def set_path_models
    @cart_product = CartProduct.find(params[:id]) if params[:id]
    set_product
  end

  def set_product
    if @cart_product
      @product = @cart_product.product
    elsif params[:product_id]
      @product = Product.find(params[:product_id])
    end
  end
end
