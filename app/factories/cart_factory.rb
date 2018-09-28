# frozen_string_literal: true

class CartFactory
  SESSION_KEY = :cart_id
  class << self
    def session_or_create(session)
      cart = Cart.find_by(id: session[SESSION_KEY])
      cart.presence || create(session)
    end

    def create(session)
      Cart.create.tap do |cart|
        session[SESSION_KEY] = cart.id
      end
    end
  end
end
