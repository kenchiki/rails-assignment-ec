class CreateProductPublishes < ActiveRecord::Migration[5.2]
  def change
    create_table :product_publishes do |t|
      t.references :product, foreign_key: true, null: false
      t.boolean :published, null: false, default: true

      t.timestamps
    end
  end
end
