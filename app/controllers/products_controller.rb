# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_presenter
  before_action :authenticate_user!, except: %i[index]

  def index
  end

  private

  def set_presenter
    @presenter = ProductPresenter.new(params: params)
  end
end
