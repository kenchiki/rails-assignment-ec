require 'rails_helper'

describe '代引き手数料管理', type: :system do
  before do
    user = FactoryBot.create(:user)
    user.create_administrator!
    sign_in user
  end

  describe '代引き手数料の追加、編集、削除' do
    let!(:first_cash_on_delivery) do
      FactoryBot.create(:cash_on_delivery, cash_on_delivery_fees_attributes: [{ began_price: 0, fee: 300 }])
    end

    it '現在の日時で代引き手数料追加' do
      visit new_admin_cash_on_delivery_path
      find(:test, 'cash-on-delivery__add').click
      find("[id^='cash_on_delivery_cash_on_delivery_fees_attributes_'][id$='_began_price']").set('0')
      find("[id^='cash_on_delivery_cash_on_delivery_fees_attributes_'][id$='_fee']").set('400')
      find("#new_cash_on_delivery [name='commit']").click

      second_cash_on_delivery_fee = CashOnDeliveryFee.last
      expect(find(:test, "cash-on-delivery-fee__began_price_#{second_cash_on_delivery_fee.id}")).to have_content '0'
      expect(find(:test, "cash-on-delivery-fee__fee_#{second_cash_on_delivery_fee.id}")).to have_content '400'
    end

    it '未来の日時で代引き手数料追加する' do
      visit new_admin_cash_on_delivery_path
      find(:test, 'cash-on-delivery__add').click
      find("[id^='cash_on_delivery_cash_on_delivery_fees_attributes_'][id$='_began_price']").set('0')
      find("[id^='cash_on_delivery_cash_on_delivery_fees_attributes_'][id$='_fee']").set('400')
      all('#cash_on_delivery_began_at_1i option').last.select_option
      find("#new_cash_on_delivery [name='commit']").click

      first_cash_on_delivery_fee = first_cash_on_delivery.cash_on_delivery_fees.last
      expect(find(:test, "cash-on-delivery-fee__began_price_#{first_cash_on_delivery_fee.id}")).to have_content '0'
      expect(find(:test, "cash-on-delivery-fee__fee_#{first_cash_on_delivery_fee.id}")).to have_content '300'

      second_cash_on_delivery_fee = CashOnDeliveryFee.last
      expect(second_cash_on_delivery_fee.began_price).to eq 0
      expect(second_cash_on_delivery_fee.fee).to eq 400
    end

    it '未来の日時の代引き手数料を変更する' do
      second_cash_on_delivery = FactoryBot.create(:cash_on_delivery,
                                                  began_at: Time.current.tomorrow,
                                                  cash_on_delivery_fees_attributes: [{ began_price: 0, fee: 400 }])

      visit edit_admin_cash_on_delivery_path(second_cash_on_delivery)
      find("[id$='_fee'][id^='cash_on_delivery_cash_on_delivery_fees_attributes_']").set('500')
      find("[id^='edit_cash_on_delivery_'] [name='commit']").click
      second_cash_on_delivery_fee = second_cash_on_delivery.reload.cash_on_delivery_fees.last
      expect(second_cash_on_delivery_fee.fee).to eq 500
    end

    it '未来の日時の代引き手数料を削除する' do
      second_cash_on_delivery = FactoryBot.create(:cash_on_delivery,
                                                  began_at: Time.current.tomorrow,
                                                  cash_on_delivery_fees_attributes: [{ began_price: 0, fee: 400 }])

      visit admin_cash_on_deliveries_path
      expect do
        accept_confirm do
          find(:test, "cash-on-delivery__destroy_#{second_cash_on_delivery.id}").click
        end
        expect(page).to have_selector "[data-test='flash__success']"
      end.to change(CashOnDelivery, :count).by(-1)
    end
  end
end
