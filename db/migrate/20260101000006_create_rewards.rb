class CreateRewards < ActiveRecord::Migration[8.0]
  def change
    create_table :rewards do |t|
      t.references :user,        null: false, foreign_key: true
      t.string     :tier,        null: false
      t.boolean    :met,         null: false, default: false
      t.text       :description
      t.string     :count_label

      t.timestamps
    end

    add_index :rewards, :tier
  end
end
