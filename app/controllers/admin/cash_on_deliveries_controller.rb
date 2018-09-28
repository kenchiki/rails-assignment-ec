# frozen_string_literal: true

module Admin
  class CashOnDeliveriesController < AdministratorController
    attr_reader :presenter
    before_action :set_presenter
    delegate :cod, to: :presenter, prefix: true

    include BeganExcludable
    before_action -> { exclude_began(presenter_cod) }

    def create
      presenter.cod = CashOnDelivery.new(cod_params)
      return render :new unless presenter_cod.save
      redirect_to admin_cash_on_deliveries_path, notice: t('.success')
    end

    def update
      return render :edit unless presenter_cod.update(cod_params)
      redirect_to admin_cash_on_deliveries_path, notice: t('.success')
    end

    def destroy
      presenter_cod.destroy!
      redirect_to admin_cash_on_deliveries_path, notice: t('.success')
    end

    private

    def set_presenter
      @presenter = CashOnDeliveryPresenter.new(params: params)
    end

    def cod_params
      params.require(:cash_on_delivery).permit(
        :began_at,
        cash_on_delivery_fees_attributes: %i[id began_price fee _destroy]
      )
    end
  end
end
