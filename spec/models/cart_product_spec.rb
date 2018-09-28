require 'rails_helper'

RSpec.describe CartProduct, type: :model do
  describe '#adjust_quantity' do
    let(:product) { FactoryBot.create(:product) }
    let(:cart_product_attributes) { FactoryBot.attributes_for(:cart_product, quantity: 1, product: product) }
    let(:cart) do
      FactoryBot.create(:cart) do |cart|
        cart.cart_products.create(cart_product_attributes)
      end
    end

    context 'カートに製品を追加し、同一製品の合計個数が最大個数を越えた場合' do
      before do
        cart.cart_products.create(FactoryBot.attributes_for(:cart_product, quantity: CartProduct::MAX_QUANTITY, product: product))
      end

      it '最大個数に製品数を調整する' do
        expect(cart.cart_products.reload.last.quantity).to eq CartProduct::MAX_QUANTITY
      end
    end

    context 'カートに製品を追加し、同一製品の合計個数が最大個数を越えなかった場合' do
      before do
        cart.cart_products.create(FactoryBot.attributes_for(:cart_product, quantity: 1, product: product))
      end

      it '同一製品の個数が追加される' do
        expect(cart.cart_products.reload.last.quantity).to eq 2
      end
    end
  end

  describe '#validates' do
    context '製品の個数が0の場合' do
      let(:cart_product) { FactoryBot.build(:cart_product, quantity: 0) }

      it 'バリデーションが失敗する' do
        expect(cart_product).not_to be_valid
      end
    end

    context '製品の個数が1の場合' do
      let(:cart_product) { FactoryBot.build(:cart_product, quantity: 1) }

      it 'バリデーションが成功する' do
        expect(cart_product).to be_valid
      end
    end

    context '製品の個数が最大数の場合' do
      let(:cart_product) { FactoryBot.build(:cart_product, quantity: CartProduct::MAX_QUANTITY) }

      it 'バリデーションが成功する' do
        expect(cart_product).to be_valid
      end
    end

    context '製品の個数が最大数より多い場合' do
      let(:cart_product) { FactoryBot.build(:cart_product, quantity: CartProduct::MAX_QUANTITY + 1) }

      it 'バリデーションが失敗する' do
        expect(cart_product).not_to be_valid
      end
    end
  end

  describe ProductPublishedValidator do
    context '製品が公開されていない場合' do
      let(:cart_product) do
        product = FactoryBot.create(:product, :unpublished)
        FactoryBot.build(:cart_product, product: product)
      end

      it 'バリデーションが失敗する' do
        expect(cart_product).not_to be_valid
      end
    end

    context '製品が公開されている場合' do
      let(:cart_product) do
        product = FactoryBot.create(:product, :published)
        FactoryBot.build(:cart_product, product: product)
      end

      it 'バリデーションが成功する' do
        expect(cart_product).to be_valid
      end
    end
  end
end
