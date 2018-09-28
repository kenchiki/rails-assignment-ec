# frozen_string_literal: true

require 'active_support/concern'

module BasicAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :basic_authentication

    def basic_authentication
      return unless Rails.env.production?
      basic_auth_username = ENV['BASIC_AUTH_USERNAME']
      basic_auth_password = ENV['BASIC_AUTH_PASSWORD']
      return if basic_auth_username.nil? || basic_auth_password.nil?
      self.class.http_basic_authenticate_with name: basic_auth_username, password: basic_auth_password
    end
  end
end
