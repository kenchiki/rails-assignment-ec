class CreateCartProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :cart_products do |t|
      t.references :product, foreign_key: true, null: false
      t.references :cart, foreign_key: true, null: false
      t.integer :quantity, null: false

      t.timestamps
    end
  end
end
