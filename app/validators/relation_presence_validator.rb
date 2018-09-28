# frozen_string_literal: true

class RelationPresenceValidator < ActiveModel::Validator
  def validate(record)
    relations = options[:relations].map { |relation| record.send(relation) }
    return if relations.all?(&:any?)
    error = options[:error].presence || :relation_empty
    record.errors.add(:base, error)
  end
end
