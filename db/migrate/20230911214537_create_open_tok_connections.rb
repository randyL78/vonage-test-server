class CreateOpenTokConnections < ActiveRecord::Migration[6.1]
  def change
    create_table :open_tok_connections do |t|
      t.string :session_id
      t.string :connection_id, index: true
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
