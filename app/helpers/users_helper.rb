# frozen_string_literal: true

module UsersHelper
  def administrator?
    return false unless current_user
    current_user.administrator?
  end

  def has_shipping_address?
    return false unless current_user
    current_user.has_shipping_address?
  end
end
