class CreateReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :reviews do |t|
      t.references :property, null: false, foreign_key: true
      t.string  :author,      null: false
      t.integer :rating
      t.text    :body,        null: false

      t.timestamps
    end

    add_index :reviews, :rating
  end
end
