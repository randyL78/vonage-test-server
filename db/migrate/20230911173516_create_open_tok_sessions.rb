class CreateOpenTokSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :open_tok_sessions do |t|
      t.string :session_id, index: true
      t.string :location
      t.string :media_mode
      t.string :archive_mode
      t.string :api_key
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
