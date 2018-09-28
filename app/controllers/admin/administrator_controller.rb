# frozen_string_literal: true

module Admin
  class AdministratorController < ApplicationController
    before_action :verify_administrator

    def verify_administrator
      redirect_to root_path unless current_user.administrator?
    end
  end
end
