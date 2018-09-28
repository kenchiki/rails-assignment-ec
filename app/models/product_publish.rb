# frozen_string_literal: true

class ProductPublish < ApplicationRecord
  belongs_to :product

  include CreatedFindable

  scope :joins_latest, -> {
    joins("INNER JOIN (#{group_product.to_sql}) group_product
             ON product_publishes.id = group_product.id")
  }
  scope :group_product, -> {
    group(:product_id).select('product_id, MAX(id) as id')
  }

  def self.last_published?
    id_asc.last.published
  end
end
