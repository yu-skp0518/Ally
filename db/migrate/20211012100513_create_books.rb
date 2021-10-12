class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.integer :user_id, null: false
      t.integer :genre_id, null: false
      t.integer :subject_id, null: false
      t.bigint :isbn, null: false
      t.string :title, null: false
      t.string :author, null: false
      t.text :itemCaption, null: false
      t.string :itemUrl, null: false
      t.string :publisherName, null: false
      t.integer :itemPrice, null: false
      t.string :mediumImageUrl, null: false
      t.string :smallImageUrl, null: false
      t.text :story, null: false
      t.float :rate, null: false
      t.boolean :is_deleted, null: false, default: false

      t.timestamps
    end
  end
end
