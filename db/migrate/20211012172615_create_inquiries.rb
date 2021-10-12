class CreateInquiries < ActiveRecord::Migration[5.2]
  def change
    create_table :inquiries do |t|
      t.integer :user_id, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.integer :status, null: false, default: 0
      t.integer :category, null: false, default: 0
      t.string :title, null: false
      t.text :body, null: false

      t.timestamps
    end
  end
end
