class CreateQualityChecks < ActiveRecord::Migration[8.0]
  def change
    create_table :quality_checks do |t|
      t.references :property,  null: false, foreign_key: true
      t.string     :guest_name, null: false
      t.datetime   :check_in,  null: false
      t.text       :note
      t.string     :state,     null: false, default: "scheduled"
      t.integer    :pct,       null: false, default: 0
      t.jsonb      :rooms,     default: [], null: false

      t.timestamps
    end

    add_index :quality_checks, :state
    add_index :quality_checks, :check_in
  end
end
