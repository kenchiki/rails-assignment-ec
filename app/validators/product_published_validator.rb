# frozen_string_literal: true

class ProductPublishedValidator < ActiveModel::Validator
  def validate(record)
    product = record.send(:product)
    return if product.last_published?
    record.errors.add(:base, :product_not_published)
  end
end
