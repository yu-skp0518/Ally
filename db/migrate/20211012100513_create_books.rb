class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.integer :user_id, null: false
      t.integer :genre_id, null: false
      t.integer :subject_id, null: false
      t.bigint :isbn, null: false
      t.string :title, null: false
      t.string :author, null: false
      t.text :item_caption, null: false
      t.string :item_url, null: false
      t.string :publisher_name, null: false
      t.integer :item_price, null: false
      t.string :large_image_url, null: false
      t.string :medium_image_url, null: false
      t.string :small_image_url, null: false
      t.text :story, null: false
      t.float :rate
      t.boolean :is_deleted, null: false, default: false

      t.timestamps
    end
  end
end
