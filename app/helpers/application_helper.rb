# frozen_string_literal: true

module ApplicationHelper
  def with_query(path)
    query_inclusion = QueryInclusion.new(request: request)
    query_inclusion.translate(path)
  end

  def t_model(path)
    t("activerecord.attributes.#{path}")
  end

  def t_common(path)
    t("common.#{path}")
  end
end
