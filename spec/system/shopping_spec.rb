require 'rails_helper'

describe 'ショッピング', type: :system do

  describe '配送先入力' do
    let(:user) { FactoryBot.create(:user) }

    before do
      user.create_administrator!
      sign_in user
    end

    it '配送先入力' do
      visit new_user_shipping_address_path(user)
      find('#shipping_address_name').set('Name1')
      find('#shipping_address_address').set('Address1')
      find('#shipping_address_post').set('Post1')
      find('#shipping_address_tel').set('Tel1')
      expect { find("#new_shipping_address [name='commit']").click }.to change(ShippingAddress, :count).by(1)
    end
  end

  describe 'カートに商品を入れて、注文する' do
    let(:user) { FactoryBot.create(:user, :with_shipping_address) }

    before do
      user.create_administrator!
      sign_in user

      FactoryBot.create(:tax, rate: 8)
      FactoryBot.create(:delivery_fee, fee: 600, per: 5)
      FactoryBot.create(:cash_on_delivery, cash_on_delivery_fees_attributes: [{ began_price: 0, fee: 300 }])
      FactoryBot.create(:delivery_time)
    end

    let!(:product) { FactoryBot.create(:product) }

    it 'カートに商品を入れて、注文する' do
      visit products_path
      find(:test, "product__show_#{product.id}").click
      find("#new_cart_product  [name='commit']").click
      find(:test, 'order__new').click
      expect { find("#new_order  [name='commit']").click }.to change(Order, :count).by(1)
    end
  end
end
