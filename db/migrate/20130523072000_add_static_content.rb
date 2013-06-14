class AddStaticContent < ActiveRecord::Migration
  def change
    create_table :static_contents do |t|
      t.string :page
      t.string :part
      t.text :body
    end
  end
end
