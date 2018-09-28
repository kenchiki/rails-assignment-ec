# frozen_string_literal: true

class Tax < ApplicationRecord
  validates :rate, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :rate, presence: true
  validates :began_at, presence: true
  before_destroy BeganExclusion.new

  include BeganFindable

  def calc_tax(price)
    (price * rate / 100).floor
  end

  def current_tax?
    self == self.class.began_last
  end
end
