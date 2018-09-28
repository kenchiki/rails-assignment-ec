# frozen_string_literal: true

class User < ApplicationRecord
  has_one :administrator, dependent: :destroy
  has_many :shipping_addresses, dependent: :destroy
  has_many :orders, -> { order(id: :desc) }, dependent: :destroy

  delegate :name, :address, :post, :tel, to: :shipping_address_last

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable

  scope :pager, ->(params) { id_desc.page(params[:page]) }

  validates :email, presence: true

  def shipping_address_last
    shipping_addresses.id_asc.last
  end

  def shipping_address_last_or_new
    shipping_addresses.id_asc.last_dup_or_new
  end

  def has_shipping_address?
    shipping_addresses.any?
  end

  def administrator?
    !!administrator
  end
end
