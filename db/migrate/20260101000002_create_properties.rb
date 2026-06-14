class CreateProperties < ActiveRecord::Migration[8.0]
  def change
    create_table :properties do |t|
      # Card / listing fields
      t.string  :name,         null: false
      t.string  :place,        null: false
      t.string  :sub
      t.string  :dates
      t.integer :price
      t.decimal :rating,       precision: 3, scale: 2
      t.integer :reviews,      default: 0
      t.boolean :favorite,     default: false
      t.string  :badge

      # Photos stored as JSONB array of URL strings
      t.jsonb   :photos,       default: [], null: false

      # Detail / host info
      t.string  :host_name
      t.string  :host_initial
      t.integer :guests
      t.integer :bedrooms
      t.integer :beds
      t.decimal :baths,        precision: 4, scale: 1
      t.text    :description

      # Complex detail stored as JSONB
      t.jsonb   :amenities,    default: [], null: false
      t.jsonb   :quality_rooms, default: [], null: false

      # FK to owning host user (optional — properties may not yet be linked)
      t.references :host, foreign_key: { to_table: :users }, null: true

      t.timestamps
    end

    add_index :properties, :place
    add_index :properties, :price
    add_index :properties, :rating
  end
end
