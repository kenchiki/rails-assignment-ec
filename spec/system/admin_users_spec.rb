require 'rails_helper'

describe 'ユーザー管理', type: :system do
  before do
    user = FactoryBot.create(:user)
    user.create_administrator!
    sign_in user
  end

  describe 'ユーザー編集、削除' do
    let!(:user) { FactoryBot.create(:user) }
    let(:user_attributes) { FactoryBot.attributes_for(:user) }

    it 'ユーザー編集' do
      visit edit_admin_user_path(user)
      find('#user_email').set(user_attributes[:email])
      expect { find("[id^='edit_user_'] [name='commit']").click }.to change { ActionMailer::Base.deliveries.size }.by(1)

      user.reload
      token = user.confirmation_token
      visit user_confirmation_path(confirmation_token: token)
      user.reload
      expect(user.email).to eq user_attributes[:email]
      expect(page).to have_selector "[data-test='flash__success']"
    end

    it 'ユーザー削除' do
      visit admin_users_path
      expect do
        accept_confirm do
          find(:test, "user__destroy_#{user.id}").click
        end
        expect(page).to have_selector "[data-test='flash__success']"
      end.to change(User, :count).by(-1)
    end

  end
end
