class AddPortfolioItems < ActiveRecord::Migration
  def up
    create_table :portfolio_items
    %w{title description image_filename_1 image_filename_2 image_filename_3 thumbnail_filename}.each do |c|
      add_column :portfolio_items, c.to_sym, (c == "description" ? :text : :string )
    end
  end

  def down
    drop_table :portfolio_items
  end
end
