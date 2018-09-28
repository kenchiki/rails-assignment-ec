require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '#product_prices_last_or_init' do
    context '登録されている価格がある場合' do
      let(:product) { FactoryBot.create(:product) }
      let(:product_price) { ProductPrice.id_asc.last }

      it '最後に登録されたProductPriceを返す' do
        expect(product.product_prices_last_or_init).to eq product_price
      end
    end

    context '登録されている価格がない場合' do
      let(:product) { FactoryBot.build(:product) }

      it '新規のProductPriceを返す' do
        expect(product.product_prices_last_or_init).to be_a_new(ProductPrice)
      end
    end
  end

  describe '#product_publishes_last_or_init' do
    context '登録されている公開状態がある場合' do
      let(:product) { FactoryBot.create(:product, :published) }
      let(:product_publish) { ProductPublish.id_asc.last }

      it '最後に登録されたProductPublishを返す' do
        expect(product.product_publishes_last_or_init).to eq product_publish
      end
    end

    context '登録されている公開状態がない場合' do
      let(:product) { FactoryBot.build(:product) }

      it '新規のProductPublishを返す' do
        expect(product.product_publishes_last_or_init).to be_a_new(ProductPublish)
      end
    end
  end

  describe '#last_price' do
    context '価格が2度登録されている場合' do
      let(:product) { FactoryBot.create(:product, product_prices_attributes: [{ price: 500 }]) }

      before do
        product.update(FactoryBot.attributes_for(:product, product_prices_attributes: [{ price: 600 }]))
      end

      it '最後に登録された価格を返す' do
        expect(product.last_price).to eq 600
      end
    end
  end

  describe '#last_published?' do
    context '公開状態が2度登録されている場合' do
      let(:product) { FactoryBot.create(:product, :published) }

      before do
        product.update(FactoryBot.attributes_for(:product, product_publishes_attributes: [{ published: false }]))
      end

      it '最後に登録された公開状態を返す' do
        expect(product.last_published?).to eq false
      end
    end
  end
end
