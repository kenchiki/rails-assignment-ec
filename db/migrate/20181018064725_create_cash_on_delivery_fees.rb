class CreateCashOnDeliveryFees < ActiveRecord::Migration[5.2]
  def change
    create_table :cash_on_delivery_fees do |t|
      t.references :cash_on_delivery, foreign_key: true, null: false
      t.integer :began_price, null: false
      t.integer :fee, null: false

      t.timestamps
    end
  end
end
