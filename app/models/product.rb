# frozen_string_literal: true

class Product < ApplicationRecord
  has_many :product_prices, dependent: :destroy
  has_many :cart_products, dependent: :restrict_with_error # カートに入れられていたら削除不可能
  has_many :product_publishes, dependent: :destroy

  accepts_nested_attributes_for :product_prices
  accepts_nested_attributes_for :product_publishes
  include AssociationFindable
  mount_uploader :image, ProductImageUploader

  acts_as_list add_new_at: :top
  scope :pager, ->(params) { order_position.page(params[:page]) }
  scope :order_position, -> { order(position: :asc) }
  scope :published, -> {
    joins_latest_publishes.where(latest_publishes: { published: true })
  }

  scope :joins_latest_publishes, -> {
    latest_publishes = ProductPublish.joins_latest
    joins("LEFT OUTER JOIN (#{latest_publishes.to_sql}) latest_publishes
             ON products.id = latest_publishes.product_id")
  }

  validates :name, presence: true
  validates_with RelationPresenceValidator, relations: %i[product_prices product_publishes]

  delegate :last_price, :ordered_price, to: :product_prices
  delegate :last_published?, to: :product_publishes

  def product_prices_last_or_init
    association_last_or_init(product_prices)
  end

  def product_publishes_last_or_init
    association_last_or_init(product_publishes)
  end
end
