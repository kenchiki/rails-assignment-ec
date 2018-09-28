# frozen_string_literal: true

module Admin
  class UsersController < AdministratorController
    attr_reader :presenter
    before_action :set_presenter

    def index
    end

    def show
    end

    def edit
    end

    def update
      return render :edit unless presenter.user.update(user_params)
      redirect_to admin_users_path, notice: t('.success')
    end

    def destroy
      presenter.user.destroy!
      redirect_to admin_users_path, notice: t('.success')
    end

    private

    def set_presenter
      @presenter = Admin::UserPresenter.new(params: params)
    end

    def user_params
      params.require(:user).permit(:email)
    end
  end
end
