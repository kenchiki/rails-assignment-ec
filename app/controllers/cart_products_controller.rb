# frozen_string_literal: true

class CartProductsController < ApplicationController
  attr_reader :presenter
  before_action :set_presenter
  before_action :authenticate_user!, except: %i[new create index edit update destroy]

  def new
    raise ActiveRecord::RecordNotFound unless presenter.product.last_published?
  end

  def index
  end

  def create
    presenter.cart_product = current_cart.cart_products.new(cart_product_params)
    presenter.cart_product.product = presenter.product
    return render :new unless presenter.cart_product.save
    redirect_to cart_products_path, notice: adjust_quantity_notice
  end

  def update
    return render :edit unless presenter.cart_product.update(cart_product_params)
    redirect_to cart_products_path, notice: adjust_quantity_notice
  end

  def destroy
    presenter.cart_product.destroy!
    redirect_to cart_products_path, notice: t('.success')
  end

  private

  def adjust_quantity_notice
    return t('.success') unless presenter.cart_product.notice
    t(presenter.cart_product.notice,
      product: presenter.cart_product.product_name,
      max_quantity: CartProduct::MAX_QUANTITY)
  end

  def set_presenter
    @presenter = CartProductPresenter.new(params: params,
                                          cart: current_cart)
  end

  def cart_product_params
    params.require(:cart_product).permit(
      :quantity
    )
  end
end
