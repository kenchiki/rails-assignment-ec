class CreateCashOnDeliveries < ActiveRecord::Migration[5.2]
  def change
    create_table :cash_on_deliveries do |t|
      t.datetime :began_at, null: false

      t.timestamps
    end
  end
end
