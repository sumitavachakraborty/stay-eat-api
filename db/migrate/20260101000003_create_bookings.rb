class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.references :user,     null: false, foreign_key: true
      t.references :property, null: false, foreign_key: true
      t.date    :check_in,    null: false
      t.date    :check_out,   null: false
      t.integer :guests,      default: 1
      t.string  :status,      null: false, default: "confirmed"

      t.timestamps
    end

    add_index :bookings, :status
    add_index :bookings, :check_in
  end
end
