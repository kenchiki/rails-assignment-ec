# frozen_string_literal: true

class DeliveryFee < ApplicationRecord
  validates :per, numericality: { greater_than_or_equal_to: 0, only_integer: true }, allow_blank: true
  validates :per, presence: true
  validates :fee, numericality: { greater_than_or_equal_to: 0, only_integer: true }, allow_blank: true
  validates :fee, presence: true
  validates :began_at, presence: true

  include BeganFindable

  def calc_deliver_fee(products_quantity)
    number = BigDecimal(products_quantity.to_s) / BigDecimal(per.to_s)
    number.ceil * fee
  end

  def current_delivery_fee?
    self == self.class.began_last
  end
end
