require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#shipping_address' do
    context '注文後の配送情報を変更した場合' do
      let(:user) { FactoryBot.create(:user) }
      let!(:shipping_address) { FactoryBot.create(:shipping_address, user: user) }
      let(:cart) { FactoryBot.create(:cart, :with_cart_product) }
      let!(:order) { FactoryBot.create(:order, user: user, cart: cart) }

      before do
        FactoryBot.create(:shipping_address, user: user)
      end

      it '注文時の配送情報を返す' do
        expect(order.shipping_address).to eq shipping_address
      end
    end
  end

  describe RelationPresenceValidator do
    context 'カートの中身に商品があり、配送情報が登録済みの場合' do
      let(:cart) { FactoryBot.create(:cart, :with_cart_product) }
      let(:order) { FactoryBot.build(:order, :with_shipping_address, cart: cart) }

      it 'バリデーションが成功する' do
        expect(order).to be_valid
      end
    end

    context 'カートの中身が空の場合' do
      let(:cart) { FactoryBot.create(:cart) }
      let(:order) { FactoryBot.build(:order, :with_shipping_address, cart: cart) }

      it 'バリデーションが失敗する' do
        expect(order).not_to be_valid
      end
    end

    context '配送情報が未登録の場合' do
      let(:cart) { FactoryBot.create(:cart, :with_cart_product) }
      let(:order) { FactoryBot.build(:order, cart: cart) }

      it 'バリデーションが失敗する' do
        expect(order).not_to be_valid
      end
    end
  end

  describe DeliveryDateInclusionValidator do
    context '2営業日目の配送日を指定した場合' do
      let(:cart) { FactoryBot.create(:cart, :with_cart_product) }
      let(:order) { FactoryBot.build(:order, :with_shipping_address, cart: cart, delivery_date: Date.new(2018, 1, 3)) }

      # 2018/1の営業日
      # 1(月) 2(火) 3(水) 4(木) 5(金) 8(月) 9(火) 10(水) 11(木) 12(金) 15(月) 16(火) 17(水) 18(木)
      around do |it|
        travel_to(Time.zone.local(2018, 1, 1, 0, 0, 0)) do
          it.run
        end
      end

      it 'バリデーションが失敗する' do
        expect(order).not_to be_valid
      end
    end

    context '3営業日目の配送日を指定した場合' do
      let(:cart) { FactoryBot.create(:cart, :with_cart_product) }
      let(:order) { FactoryBot.build(:order, :with_shipping_address, cart: cart, delivery_date: Date.new(2018, 1, 4)) }

      # 2018/1の営業日
      # 4(木) 5(金) 8(月) 9(火) 10(水) 11(木) 12(金) 15(月) 16(火) 17(水) 18(木)
      around do |it|
        travel_to(Time.zone.local(2018, 1, 1, 0, 0, 0)) do
          it.run
        end
      end

      it 'バリデーションが成功する' do
        expect(order).to be_valid
      end
    end

    context '14営業日目の配送日を指定した場合' do
      let(:cart) { FactoryBot.create(:cart, :with_cart_product) }
      let(:order) { FactoryBot.build(:order, :with_shipping_address, cart: cart, delivery_date: Date.new(2018, 1, 18)) }

      # 2018/1の営業日
      # 4(木) 5(金) 8(月) 9(火) 10(水) 11(木) 12(金) 15(月) 16(火) 17(水) 18(木)
      around do |it|
        travel_to(Time.zone.local(2018, 1, 1, 0, 0, 0)) do
          it.run
        end
      end

      it 'バリデーションが成功する' do
        expect(order).to be_valid
      end
    end

    context '15営業日目の配送日を指定した場合' do
      let(:cart) { FactoryBot.create(:cart, :with_cart_product) }
      let(:order) { FactoryBot.build(:order, :with_shipping_address, cart: cart, delivery_date: Date.new(2018, 1, 19)) }

      # 2018/1の営業日
      # 4(木) 5(金) 8(月) 9(火) 10(水) 11(木) 12(金) 15(月) 16(火) 17(水) 18(木)
      around do |it|
        travel_to(Time.zone.local(2018, 1, 1, 0, 0, 0)) do
          it.run
        end
      end

      it 'バリデーションが失敗する' do
        expect(order).not_to be_valid
      end
    end
  end
end
