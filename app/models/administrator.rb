# frozen_string_literal: true

class Administrator < ApplicationRecord
  belongs_to :user

  delegate :email, to: :user

  def self.emails
    all.map(&:email)
  end
end
