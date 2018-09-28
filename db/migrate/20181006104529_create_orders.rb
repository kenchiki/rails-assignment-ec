class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :cart, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.references :delivery_time, foreign_key: true, null: false
      t.date :delivery_date, null: false

      t.timestamps
    end
  end
end
