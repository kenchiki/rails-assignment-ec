require 'rails_helper'

describe '商品管理', type: :system do
  before do
    user = FactoryBot.create(:user)
    user.create_administrator!
    sign_in user
  end

  describe '商品の追加、編集、削除' do
    it '商品追加' do
      visit new_admin_product_path
      find('#product_name').set('Product1')
      find("[id$='_price'][id^='product_product_prices_attributes_']").set('500')
      find("#new_product [name='commit']").click
      product = Product.last
      product_price = product.product_prices.last
      expect(product.name).to eq 'Product1'
      expect(product_price.price).to eq 500
    end

    it '商品編集' do
      product = FactoryBot.create(:product, name: 'Product1', product_prices_attributes: [{ price: 500 }])

      visit edit_admin_product_path(product)
      find('#product_name').set('Product2')
      find("[id$='_price'][id^='product_product_prices_attributes_']").set('600')
      find("[id^='edit_product_'] [name='commit']").click
      product.reload
      product_price = product.product_prices.last
      expect(product.name).to eq 'Product2'
      expect(product_price.price).to eq 600
    end

    it '商品削除' do
      product = FactoryBot.create(:product, name: 'Product1')

      visit admin_products_path
      expect do
        accept_confirm do
          find(:test, "product__destroy_#{product.id}").click
        end
        expect(page).to have_selector "[data-test='flash__success']"
      end.to change(Product, :count).by(-1)
    end
  end

  describe '商品並び替え' do
    let!(:first_product) { FactoryBot.create(:product, name: 'Product1') }
    let!(:second_product) { FactoryBot.create(:product, name: 'Product2') }
    let!(:third_product) { FactoryBot.create(:product, name: 'Product3') }

    it '商品を一つ上に並び替える' do
      visit admin_products_path
      expect do
        find(:test, "product__up_#{first_product.id}").click
      end.to change {
        Product.order_position.to_a
      }.from([third_product, second_product, first_product]).to([third_product, first_product, second_product])
    end

    it '商品を一つ下に並び替える' do
      visit admin_products_path
      expect do
        find(:test, "product__down_#{third_product.id}").click
      end.to change {
        Product.order_position.to_a
      }.from([third_product, second_product, first_product]).to([second_product, third_product, first_product])
    end

    it '商品を一番上に並び替える' do
      visit admin_products_path
      expect do
        accept_confirm do
          find(:test, "product__top_#{first_product.id}").click
        end
        expect(page).to have_selector "[data-test='flash__success']"
      end.to change {
        Product.order_position.to_a
      }.from([third_product, second_product, first_product]).to([first_product, third_product, second_product])
    end

    it '商品を一番下に並び替える' do
      visit admin_products_path
      expect do
        accept_confirm do
          find(:test, "product__bottom_#{third_product.id}").click
        end
        expect(page).to have_selector "[data-test='flash__success']"
      end.to change {
        Product.order_position.to_a
      }.from([third_product, second_product, first_product]).to([second_product, first_product, third_product])
    end
  end
end
