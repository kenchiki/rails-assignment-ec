require 'rails_helper'

describe '税率管理', type: :system do
  before do
    user = FactoryBot.create(:user)
    user.create_administrator!
    sign_in user
  end

  describe '税率の追加、編集、削除' do
    before do
      FactoryBot.create(:tax, rate: 8)
    end

    it '現在の日時で税率追加' do
      visit new_admin_tax_path
      find('#tax_rate').set('10')
      find("#new_tax [name='commit']").click
      expect(find(:test, 'tax__current_rate')).to have_content '10.0'
    end

    it '未来の日時で税率追加' do
      visit new_admin_tax_path
      find('#tax_rate').set('10')
      all('#tax_began_at_1i option').last.select_option
      find("#new_tax [name='commit']").click
      expect(find(:test, 'tax__current_rate')).to have_content '8.0'
      tax = Tax.last
      expect(tax.rate).to eq 10
    end

    it '未来の日時の税率を編集' do
      tax = FactoryBot.create(:tax, began_at: Time.current.tomorrow, rate: 10)

      visit edit_admin_tax_path(tax)
      find('#tax_rate').set('11')
      find("[id^='edit_tax_'] [name='commit']").click
      tax.reload
      expect(tax.rate).to eq 11
    end

    it '未来の日時の税率を削除' do
      tax = FactoryBot.create(:tax, began_at: Time.current.tomorrow, rate: 10)

      visit admin_taxes_path
      expect do
        accept_confirm do
          find(:test, "tax__destroy_#{tax.id}").click
        end
        expect(page).to have_selector "[data-test='flash__success']"
      end.to change(Tax, :count).by(-1)
    end
  end
end
