class AddPositionToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :position, :integer, null: false, default: 1
    Product.order(updated_at: :desc).each.with_index(1) do |product, index|
      product.update_column :position, index
    end
  end
end
