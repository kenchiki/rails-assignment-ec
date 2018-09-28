# frozen_string_literal: true

module Admin
  class OrdersController < AdministratorController
    attr_reader :presenter
    before_action :set_presenter

    def index
    end

    def show
    end

    private

    def set_presenter
      @presenter = Admin::OrderPresenter.new(params: params)
    end
  end
end
