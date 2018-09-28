# frozen_string_literal: true

require 'active_support/concern'

module IdOrderable
  extend ActiveSupport::Concern

  included do
    scope :id_desc, -> { order(id: :desc) }
    scope :id_asc, -> { order(id: :asc) }
  end
end
