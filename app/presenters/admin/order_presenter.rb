# frozen_string_literal: true

module Admin
  class OrderPresenter
    attr_accessor :order
    attr_reader :params

    def initialize(args)
      @params = args[:params]
      set_path_models
    end

    def orders
      Order.pager(params)
    end

    def set_path_models
      @order = Order.find(params[:id]) if params[:id]
    end
  end
end
