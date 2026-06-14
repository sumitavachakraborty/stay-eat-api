class CreateExperiences < ActiveRecord::Migration[8.0]
  def change
    create_table :experiences do |t|
      t.string  :slug,      null: false
      t.string  :name,      null: false
      t.string  :place
      t.string  :host_name, null: false
      t.integer :price
      t.string  :img

      t.timestamps
    end

    add_index :experiences, :slug, unique: true
  end
end
