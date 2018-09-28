require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe '#ordered_at_or_current' do
    before do
      FactoryBot.create(:tax)
      FactoryBot.create(:delivery_fee)
      FactoryBot.create(:cash_on_delivery)
    end

    context '注文が完了していないカートの場合' do
      let(:cart) { FactoryBot.create(:cart) }

      around do |it|
        travel_to(Time.zone.local(2018, 1, 1, 0, 0, 0)) do
          it.run
        end
      end

      it '現在の日時を返す' do
        expect(cart.ordered_at_or_current).to eq Time.current
      end
    end

    context '注文が完了した後のカートの場合' do
      let(:ordered_cart) { FactoryBot.create(:cart, :with_cart_product) }
      # 注文が未完了だとordered_at_or_currentは現在の日付を返すためこの時点で注文を完了させておく
      let!(:order) { FactoryBot.create(:order, :with_shipping_address, cart: ordered_cart) }

      it '注文時の日時を返す' do
        expect(ordered_cart.ordered_at_or_current).to eq order.created_at
      end
    end
  end

  describe '#cart_total' do
    let(:product) { FactoryBot.create(:product, product_prices_attributes: [{ price: 500 }]) }
    let(:cart_product) { FactoryBot.attributes_for(:cart_product, quantity: 1, product: product) }
    let(:cart) do
      FactoryBot.create(:cart) do |cart|
        cart.cart_products.create(cart_product)
      end
    end

    before do
      FactoryBot.create(:tax, rate: 8)
      FactoryBot.create(:delivery_fee, fee: 1000, per: 5)
      FactoryBot.create(:cash_on_delivery, cash_on_delivery_fees_attributes: [{ began_price: 0, fee: 1500 }])
    end

    context '注文が完了していないカートの場合' do
      it '現在のカートの合計金額を返す' do
        # (1000(delivery_fee) + 1500(cash_on_delivery_fee) + 500(products_total)) * 1.08 = 3240
        expect(cart.cart_total_with_tax).to eq 3240
      end
    end

    context '注文が完了した後のカートの場合' do
      before do
        FactoryBot.create(:order, :with_shipping_address, cart: cart)
        FactoryBot.create(:tax, rate: 10)
        FactoryBot.create(:delivery_fee, fee: 1100, per: 5)
        FactoryBot.create(:cash_on_delivery, cash_on_delivery_fees_attributes: [{ began_price: 0, fee: 1600 }])
        product.update(FactoryBot.attributes_for(:product, product_prices_attributes: [{ price: 600 }]))
      end

      it '注文時の合計金額を返す' do
        # (1000(delivery_fee) + 1500(cash_on_delivery_fee) + 500(products_total)) * 1.08 = 3240
        expect(cart.cart_total_with_tax).to eq 3240
      end
    end
  end

  describe '#products_total' do
    let(:product) { FactoryBot.create(:product, product_prices_attributes: [{ price: 500 }]) }
    let(:cart_product_attributes) { FactoryBot.attributes_for(:cart_product, quantity: 1, product: product) }
    let(:cart) do
      FactoryBot.create(:cart) do |cart|
        cart.cart_products.create(cart_product_attributes)
      end
    end

    before do
      FactoryBot.create(:tax)
      FactoryBot.create(:delivery_fee)
      FactoryBot.create(:cash_on_delivery)
    end

    context '商品をカートに1つ追加した場合' do
      it '商品1つ分の小計金額を返す' do
        # 500 * 1 = 500
        expect(cart.products_total).to eq 500
      end
    end

    context '商品をカートに2つ追加した場合' do
      before do
        _cart_product = cart.cart_products.first
        _cart_product.update_attribute(:quantity, 2)
      end

      it '商品2つ分の小計金額を返す' do
        # 500 * 2 = 500
        expect(cart.products_total).to eq 1000
      end
    end
  end

  describe '#cash_on_delivery_fee' do
    let(:product) { FactoryBot.create(:product, product_prices_attributes: [{ price: 9999 }]) }
    let(:cart_product_attributes) { FactoryBot.attributes_for(:cart_product, quantity: 1, product: product) }
    let(:cart) do
      FactoryBot.create(:cart) do |cart|
        cart.cart_products.create(cart_product_attributes)
      end
    end

    before do
      FactoryBot.create(:tax)
      FactoryBot.create(:delivery_fee)
    end

    context '代引き手数料が0-10,000円未満で300円、10,000以上で400円の場合' do
      before do
        FactoryBot.create(:cash_on_delivery,
                          cash_on_delivery_fees_attributes: [{ began_price: 0, fee: 300 },
                                                             { began_price: 10000, fee: 400 }])
      end

      it '合計金額が9,999円で300円を返す' do
        expect(cart.cash_on_delivery_fee).to eq 300
      end

      it '合計金額が10,000円で400円を返す' do
        product.update(FactoryBot.attributes_for(:product, product_prices_attributes: [{ price: 10000 }]))
        expect(cart.cash_on_delivery_fee).to eq 400
      end
    end
  end

  describe '#delivery_fee' do
    let(:cart_product_attributes) { FactoryBot.attributes_for(:cart_product, quantity: 4) }
    let(:cart) do
      FactoryBot.create(:cart) do |cart|
        cart.cart_products.create(cart_product_attributes)
      end
    end

    before do
      FactoryBot.create(:tax)
      FactoryBot.create(:delivery_fee, fee: 600, per: 5)
      FactoryBot.create(:cash_on_delivery)
    end

    context '送料は5商品ごとに600円追加する場合' do
      it '4商品の時、600円を返す' do
        expect(cart.delivery_fee).to eq 600
      end

      it '5商品の時、600円を返す' do
        _cart_product = cart.cart_products.first
        _cart_product.update_attribute(:quantity, 5)
        expect(cart.delivery_fee).to eq 600
      end

      it '6商品の時、1,200円を返す' do
        _cart_product = cart.cart_products.first
        _cart_product.update_attribute(:quantity, 6)
        expect(cart.delivery_fee).to eq 1200
      end
    end
  end
end
