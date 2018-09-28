class ShippingAddress < ApplicationRecord
  belongs_to :user

  include CreatedFindable

  validates :name, :address, :post, :tel, presence: true

  def self.last_dup_or_new
    return last.dup if last
    new
  end
end
