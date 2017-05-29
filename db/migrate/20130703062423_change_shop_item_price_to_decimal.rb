class ChangeShopItemPriceToDecimal < ActiveRecord::Migration[5.0]
  def change
    change_column :shop_items, :price, :decimal, precision: 8, scale: 2, default: 0.00  # max of 999,999.99
  end
end
