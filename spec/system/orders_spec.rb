require 'rails_helper'

describe '注文履歴', type: :system do
  describe 'ログインユーザーは自分の注文詳細はみれるが、他のユーザーの注文詳細は閲覧できない' do
    include_context :show_exceptions

    let(:login_user_order) do
      FactoryBot.create(:order, :with_shipping_address, cart: FactoryBot.create(:cart, :with_cart_product))
    end
    let(:other_user_order) do
      FactoryBot.create(:order, :with_shipping_address, cart: FactoryBot.create(:cart, :with_cart_product))
    end

    before do
      Capybara.current_driver = :webkit

      FactoryBot.create(:tax, rate: 8)
      FactoryBot.create(:delivery_fee, fee: 600, per: 5)
      FactoryBot.create(:cash_on_delivery, cash_on_delivery_fees_attributes: [{ began_price: 0, fee: 300 }])
      FactoryBot.create(:delivery_time)

      sign_in login_user_order.user
    end

    it '自分の注文詳細を閲覧する' do
      visit order_path(login_user_order)
      expect(page).to have_http_status(200)
    end

    it '他のユーザーの注文詳細は閲覧できない' do
      visit order_path(other_user_order)
      expect(page).to have_http_status(404)
    end
  end
end
