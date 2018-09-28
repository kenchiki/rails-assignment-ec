# frozen_string_literal: true

module Admin
  class ProductsController < AdministratorController
    attr_reader :presenter
    before_action :set_presenter
    include Sortable

    def new
    end

    def edit
    end

    def create
      presenter.product = Product.new(product_params)
      return render :new unless presenter.product.save
      redirect_to [:admin, presenter.product], notice: t('.success')
    end

    def update
      return render :edit unless presenter.product.update(product_params)
      redirect_to [:admin, presenter.product], notice: t('.success')
    end

    def destroy
      presenter.product.destroy
      notice = presenter.product.destroyed? ? t('.success') : t('.failure')
      redirect_to admin_products_path, notice: notice
    end

    private

    def set_presenter
      @presenter = Admin::ProductPresenter.new(params: params)
    end

    def product_params
      params.require(:product).permit(
        :name, :image, :remove_image, :image_cache, :description,
        product_prices_attributes: %i[price],
        product_publishes_attributes: %i[published]
      )
    end

    def sortable_model
      presenter.product
    end

    def sortable_after_path
      admin_products_path
    end
  end
end
