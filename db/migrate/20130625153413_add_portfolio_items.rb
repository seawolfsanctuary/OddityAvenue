class AddPortfolioItems < ActiveRecord::Migration[5.0]
  def up
    create_table :portfolio_items

    add_column :portfolio_items, :title, :string
    add_column :portfolio_items, :description, :text
    %w{image_filename_1 image_filename_2 image_filename_3 thumbnail_filename}.each do |c|
      add_column :portfolio_items, c.to_sym, :string
    end

    add_column :portfolio_items, :enabled, :boolean, default: true
  end

  def down
    drop_table :portfolio_items
  end
end
