require 'rails_helper'

describe '送料管理', type: :system do
  before do
    user = FactoryBot.create(:user)
    user.create_administrator!
    sign_in user
  end

  describe '送料の追加、編集、削除' do
    before do
      FactoryBot.create(:delivery_fee, fee: 600, per: 5)
    end

    it '現在の日時で送料追加' do
      visit new_admin_delivery_fee_path
      find('#delivery_fee_per').set('6')
      find('#delivery_fee_fee').set('700')
      find("#new_delivery_fee [name='commit']").click
      expect(find(:test, 'delivery-fee__current_per')).to have_content '6'
      expect(find(:test, 'delivery-fee__current_fee')).to have_content '700'
    end

    it '未来の日時で送料追加' do
      visit new_admin_delivery_fee_path
      find('#delivery_fee_per').set('6')
      find('#delivery_fee_fee').set('700')
      all('#delivery_fee_began_at_1i option').last.select_option
      find("#new_delivery_fee [name='commit']").click
      expect(find(:test, 'delivery-fee__current_per')).to have_content '5'
      expect(find(:test, 'delivery-fee__current_fee')).to have_content '600'
      delivery_fee = DeliveryFee.last
      expect(delivery_fee.per).to eq 6
      expect(delivery_fee.fee).to eq 700
    end

    it '未来の日時の送料編集' do
      delivery_fee = FactoryBot.create(:delivery_fee, began_at: Time.current.tomorrow, fee: 700, per: 6)

      visit edit_admin_delivery_fee_path(delivery_fee)
      find('#delivery_fee_per').set('7')
      find('#delivery_fee_fee').set('800')
      find("[id^='edit_delivery_fee_'] [name='commit']").click
      delivery_fee.reload
      expect(delivery_fee.per).to eq 7
      expect(delivery_fee.fee).to eq 800
    end

    it '未来の日時の送料削除' do
      delivery_fee = FactoryBot.create(:delivery_fee, began_at: Time.current.tomorrow, fee: 700, per: 6)

      visit admin_delivery_fees_path
      expect do
        accept_confirm do
          find(:test, "delivery-fee__destroy_#{delivery_fee.id}").click
        end
        expect(page).to have_selector "[data-test='flash__success']"
      end.to change(DeliveryFee, :count).by(-1)
    end
  end
end
