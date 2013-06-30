class AddSalesToPortfolio < ActiveRecord::Migration
  def change
    add_column :portfolio_items, :for_sale, :boolean, default: true
    add_column :portfolio_items, :hidden,   :boolean, default: false
  end
end
