# frozen_string_literal: true

require 'active_support/concern'

module CreatedFindable
  extend ActiveSupport::Concern

  included do
    scope :created_before_time, ->(finding_time) {
      where('created_at <= ?', finding_time)
    }

    def self.created_last_before_time(finding_time)
      created_before_time(finding_time).id_asc.last
    end
  end
end
