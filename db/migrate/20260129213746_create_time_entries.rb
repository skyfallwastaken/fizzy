class CreateTimeEntries < ActiveRecord::Migration[8.2]
  def change
    create_table :time_entries, id: :uuid do |t|
      t.uuid :account_id, null: false
      t.uuid :card_id, null: false
      t.uuid :user_id, null: false
      t.integer :duration_seconds, default: 0, null: false
      t.datetime :started_at
      t.string :note
      t.timestamps
    end

    add_index :time_entries, :account_id
    add_index :time_entries, [:card_id, :user_id]
    add_index :time_entries, [:user_id, :started_at]
  end
end
