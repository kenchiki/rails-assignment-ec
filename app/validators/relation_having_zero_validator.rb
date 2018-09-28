# frozen_string_literal: true

class RelationHavingZeroValidator < ActiveModel::Validator
  def validate(record)
    models = record.send(options[:relation])
    return if models.any? { |model| model.send(options[:field])&.zero? }
    record.errors.add(:base, :relation_not_has_zero)
  end
end
