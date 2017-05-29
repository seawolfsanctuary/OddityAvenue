class AddShopItems < ActiveRecord::Migration[5.0]
  def up
    create_table :shop_items

    add_column :shop_items, :title, :string
    add_column :shop_items, :description, test
    %w{image_filename_1 image_filename_2 image_filename_3 thumbnail_filename}.each do |c|
      add_column :shop_items, c.to_sym, :string
    end

    add_column :shop_items, :enabled, :boolean, default: true

    add_column :shop_items, :quantity, :integer, default: 1
    add_column :shop_items, :price,    :float,   default: 0.00
  end

  def down
    drop_table :shop_items
  end
end
