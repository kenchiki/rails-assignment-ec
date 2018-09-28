# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  delegate :any?, :count, :full_messages, to: :errors, prefix: true
  include IdOrderable
end
