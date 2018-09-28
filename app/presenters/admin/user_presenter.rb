# frozen_string_literal: true

module Admin
  class UserPresenter
    attr_accessor :user
    attr_reader :params

    def initialize(args)
      @params = args[:params]
      set_path_models
    end

    def users
      User.pager(params)
    end

    def set_path_models
      @user = User.find(params[:id]) if params[:id]
    end
  end
end
