# frozen_string_literal: true

class CashOnDeliveryFee < ApplicationRecord
  belongs_to :cash_on_delivery
  validates :began_price, uniqueness: { scope: :cash_on_delivery_id }
  validates :began_price, numericality: { greater_than_or_equal_to: 0, only_integer: true }, allow_blank: true
  validates :began_price, presence: true
  validates :fee, numericality: { greater_than_or_equal_to: 0, only_integer: true }, allow_blank: true
  validates :fee, presence: true

  def self.find_by_price(products_price)
    where('began_price <= ?', products_price).id_asc.last
  end
end
