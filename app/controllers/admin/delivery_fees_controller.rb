# frozen_string_literal: true

module Admin
  class DeliveryFeesController < AdministratorController
    attr_reader :presenter
    before_action :set_presenter
    delegate :delivery_fee, to: :presenter, prefix: true

    include BeganExcludable
    before_action -> { exclude_began(presenter_delivery_fee) }

    def create
      presenter.delivery_fee = DeliveryFee.new(df_params)
      return render :new unless presenter_delivery_fee.save
      redirect_to admin_delivery_fees_path, notice: t('.success')
    end

    def update
      return render :edit unless presenter_delivery_fee.update(df_params)
      redirect_to admin_delivery_fees_path, notice: t('.success')
    end

    def destroy
      presenter_delivery_fee.destroy
      notice = presenter_delivery_fee.destroyed? ? t('.success') : t('.failure')
      redirect_to admin_delivery_fees_path, notice: notice
    end

    private

    def set_presenter
      @presenter = DeliveryFeePresenter.new(params: params)
    end

    def df_params
      params.require(:delivery_fee).permit(:per, :fee, :began_at)
    end
  end
end
