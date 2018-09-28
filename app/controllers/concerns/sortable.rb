# frozen_string_literal: true

require 'active_support/concern'

module Sortable
  extend ActiveSupport::Concern

  include QueryIncludable

  def sort_up
    sortable_model&.move_higher
    redirect_after_sort
  end

  def sort_down
    sortable_model&.move_lower
    redirect_after_sort
  end

  def sort_top
    sortable_model&.move_to_top
    redirect_after_sort
  end

  def sort_bottom
    sortable_model&.move_to_bottom
    redirect_after_sort
  end

  private

  def sortable_model
    nil
  end

  def sortable_after_path
    nil
  end

  def redirect_after_sort
    redirect_to query_include(sortable_after_path), notice: t('.sort_success') if sortable_after_path
  end
end
