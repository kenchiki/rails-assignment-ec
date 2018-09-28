class CreateDeliveryFees < ActiveRecord::Migration[5.2]
  def change
    create_table :delivery_fees do |t|
      t.integer :per, null: false
      t.integer :fee, null: false
      t.datetime :began_at, null: false

      t.timestamps
    end
  end
end
