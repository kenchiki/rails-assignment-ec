# frozen_string_literal: true

module Admin
  class TaxesController < AdministratorController
    attr_reader :presenter
    before_action :set_presenter
    delegate :tax, to: :presenter, prefix: true

    include BeganExcludable
    before_action -> { exclude_began(presenter_tax) }

    def index
    end

    def new
    end

    def create
      presenter.tax = Tax.new(tax_params)
      return render :new unless presenter_tax.save
      redirect_to admin_taxes_path, notice: t('.success')
    end

    def update
      return render :edit unless presenter_tax.update(tax_params)
      redirect_to admin_taxes_path, notice: t('.success')
    end

    def destroy
      presenter_tax.destroy
      notice = presenter_tax.destroyed? ? t('.success') : t('.failure')
      redirect_to admin_taxes_path, notice: notice
    end

    private

    def set_presenter
      @presenter = TaxPresenter.new(params: params)
    end

    def tax_params
      params.require(:tax).permit(:rate, :began_at)
    end
  end
end
