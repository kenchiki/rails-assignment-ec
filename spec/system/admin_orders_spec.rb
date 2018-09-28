require 'rails_helper'

describe '注文確認（管理者用）', type: :system do
  describe '管理者は全てのユーザーの注文詳細を確認できる' do
    include_context :show_exceptions

    let(:other_user_order) do
      FactoryBot.create(:order, :with_shipping_address, cart: FactoryBot.create(:cart, :with_cart_product))
    end

    before do
      Capybara.current_driver = :webkit

      FactoryBot.create(:tax, rate: 8)
      FactoryBot.create(:delivery_fee, fee: 600, per: 5)
      FactoryBot.create(:cash_on_delivery, cash_on_delivery_fees_attributes: [{ began_price: 0, fee: 300 }])
      FactoryBot.create(:delivery_time)

      admin_user = FactoryBot.create(:user)
      admin_user.create_administrator!
      sign_in admin_user
    end

    it '管理者は全てのユーザーの注文詳細を確認できる' do
      visit admin_order_path(other_user_order)
      expect(page).to have_http_status(200)
    end
  end
end
