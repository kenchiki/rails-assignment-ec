# frozen_string_literal: true

class CashOnDelivery < ApplicationRecord
  has_many :cash_on_delivery_fees, -> { order(began_price: :asc) },
           dependent: :destroy,
           inverse_of: :cash_on_delivery

  accepts_nested_attributes_for :cash_on_delivery_fees, allow_destroy: true
  before_destroy BeganExclusion.new

  validates :began_at, presence: true
  validates_with RelationPresenceValidator, relations: %i[cash_on_delivery_fees]
  # 0円以上のものがかならず含まれるようにする
  validates_with RelationHavingZeroValidator, relation: :cash_on_delivery_fees, field: :began_price

  scope :with_cod_fees, -> { includes(:cash_on_delivery_fees) }

  include BeganFindable

  def cash_on_delivery_fee(products_price)
    _cash_on_delivery_fee(products_price).fee
  end

  def current_cash_on_delivery?
    self == self.class.began_last
  end

  private

  def _cash_on_delivery_fee(products_price)
    cash_on_delivery_fees.find_by_price(products_price)
  end
end
