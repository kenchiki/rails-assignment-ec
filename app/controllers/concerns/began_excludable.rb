# frozen_string_literal: true

require 'active_support/concern'

module BeganExcludable
  extend ActiveSupport::Concern

  def exclude_began(model)
    return unless model.began?
    redirect_path = url_for(controller: controller_path,
                            action: 'index',
                            only_path: true)
    redirect_to redirect_path, notice: t('.exclude_began')
  end
end
