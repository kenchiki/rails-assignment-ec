require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#shipping_address_last_or_new' do
    context '配送先が2度、登録されている場合' do
      let(:user) do
        FactoryBot.create(:user) do |user|
          user.shipping_addresses.create(FactoryBot.attributes_for(:shipping_address))
        end
      end

      let!(:shipping_address) { FactoryBot.create(:shipping_address, user: user) }

      it '最後に登録されているShippingAddressを返す' do
        expect(user.shipping_address_last_or_new.attributes).to eq shipping_address.dup.attributes
      end
    end

    context '配送先が登録されていない場合' do
      let(:user) { FactoryBot.create(:user) }

      it 'ShippingAddress.newを返す' do
        expect(user.shipping_address_last_or_new).to be_a_new(ShippingAddress)
      end
    end
  end

  describe '#shipping_address_last' do
    let(:user) { FactoryBot.create(:user) }

    context '1つも配送情報がない場合' do
      it 'nilを返す' do
        expect(user.shipping_address_last).to eq nil
      end
    end

    context '配送情報が1つ登録済みの場合' do
      let(:user) { FactoryBot.create(:user) }
      let!(:shipping_address) { FactoryBot.create(:shipping_address, user: user) }

      it '登録した配送情報を返す' do
        expect(user.shipping_address_last).to eq shipping_address
      end
    end

    context '配送情報が2つ登録済みの場合' do
      let(:user) do
        FactoryBot.create(:user) do |user|
          user.shipping_addresses.create(FactoryBot.attributes_for(:shipping_address))
        end
      end

      let!(:shipping_address) { FactoryBot.create(:shipping_address, user: user) }

      it '最後に登録した配送情報を返す' do
        expect(user.shipping_address_last).to eq shipping_address
      end
    end
  end
end
