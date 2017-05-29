class AddStaticContent < ActiveRecord::Migration[5.0]
  def change
    create_table :static_contents do |t|
      t.string :page
      t.string :part
      t.text :body
    end
  end
end