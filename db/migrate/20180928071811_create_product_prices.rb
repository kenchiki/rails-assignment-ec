class CreateProductPrices < ActiveRecord::Migration[5.2]
  def change
    create_table :product_prices do |t|
      t.references :product, foreign_key: true, null: false
      t.integer :price, null: false

      t.timestamps
    end
  end
end
