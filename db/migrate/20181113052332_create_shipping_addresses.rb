class CreateShippingAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :shipping_addresses do |t|
      t.references :user, foreign_key: true, null: false
      t.string :name, null: false
      t.string :address, null: false
      t.string :post, null: false
      t.string :tel, null: false

      t.timestamps
    end
  end
end
