# frozen_string_literal: true

require 'active_support/concern'

module AssociationFindable
  extend ActiveSupport::Concern

  def association_last_or_init(association)
    return association.last if association.last&.persisted?
    association.build unless association.any?
    # 入力途中のものか新しいオブジェクトを返す
    association.last
  end
end
