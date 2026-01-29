class RemoveNoteFromTimeEntries < ActiveRecord::Migration[8.2]
  def change
    remove_column :time_entries, :note
  end
end
