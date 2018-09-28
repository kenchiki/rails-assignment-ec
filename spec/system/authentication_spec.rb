require 'rails_helper'

describe '認証', type: :system do
  describe 'サインアップ後、ログイン' do
    let(:user_attributes) { FactoryBot.attributes_for(:user) }

    it 'サインアップ後、ログイン' do
      # サインアップ
      visit new_user_registration_path
      find('#user_email').set(user_attributes[:email])
      find('#user_password').set(user_attributes[:password])
      find('#user_password_confirmation').set(user_attributes[:password])
      expect { find("#new_user [name='commit']").click }.to change { ActionMailer::Base.deliveries.size }.by(1)

      # ログイン
      user = User.last
      token = user.confirmation_token
      visit user_confirmation_path(confirmation_token: token)
      find('#user_email').set(user_attributes[:email])
      find('#user_password').set(user_attributes[:password])
      find("#new_user [name='commit']").click
      expect(page).to have_selector "[data-test='flash__success']"
    end
  end

  describe 'パスワードを忘れた場合の再発行' do
    let(:user_attributes) { FactoryBot.attributes_for(:user) }
    let(:user) { FactoryBot.create(:user, user_attributes) }

    it 'パスワードを忘れた場合の再発行' do
      visit new_user_password_path
      find('#user_email').set(user.email)
      find("#new_user [name='commit']").click

      reset_token = user.send_reset_password_instructions
      visit edit_user_password_path(reset_password_token: reset_token)
      find('#user_password').set(user_attributes[:password])
      find('#user_password_confirmation').set(user_attributes[:password])
      find("#new_user [name='commit']").click
      expect(page).to have_selector "[data-test='flash__success']"
    end
  end

  describe '確認メールが届かなかった場合の再送' do
    let(:user_attributes) { FactoryBot.attributes_for(:user) }

    it '確認メールが届かなかった場合の再送' do
      # サインアップ
      visit new_user_registration_path
      find('#user_email').set(user_attributes[:email])
      find('#user_password').set(user_attributes[:password])
      find('#user_password_confirmation').set(user_attributes[:password])
      expect { find("#new_user [name='commit']").click }.to change { ActionMailer::Base.deliveries.size }.by(1)

      # メール再送
      visit new_user_confirmation_path
      find('#user_email').set(user_attributes[:email])
      find("#new_user [name='commit']").click
      expect(page).to have_selector "[data-test='flash__success']"
    end
  end
end
