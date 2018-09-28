# frozen_string_literal: true

require 'active_support/concern'

module CartFindable
  extend ActiveSupport::Concern

  private

  def current_cart
    @current_cart ||= CartFactory.session_or_create(session)
  end

  def new_cart
    @current_cart = CartFactory.create(session)
  end
end
