# frozen_string_literal: true

require 'active_support/concern'

module BeganFindable
  extend ActiveSupport::Concern

  def began?
    persisted? && began_at.past?
  end

  included do
    scope :began, -> { where('began_at <= ?', Time.current) }
    scope :began_before_time, ->(finding_time) { where('began_at <= ?', finding_time) }

    def self.began_last
      began.id_asc.last
    end

    def self.began_last_before_time(finding_time)
      began_before_time(finding_time).id_asc.last
    end
  end
end
