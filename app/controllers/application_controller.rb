# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  include CartFindable
  include BasicAuthentication

  helper_method :current_cart
end
