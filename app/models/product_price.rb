class ProductPrice < ApplicationRecord
  belongs_to :product

  include CreatedFindable

  validates :price, numericality: { greater_than_or_equal_to: 0, only_integer: true }, allow_blank: true
  validates :price, presence: true

  def self.last_price
    id_asc.last.price
  end

  def self.ordered_price(created_at)
    created_last_before_time(created_at).price
  end
end
