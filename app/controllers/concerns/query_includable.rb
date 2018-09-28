# frozen_string_literal: true

require 'active_support/concern'

module QueryIncludable
  extend ActiveSupport::Concern

  def query_include(path)
    query_inclusion = QueryInclusion.new(request: request)
    query_inclusion.translate(path)
  end
end
