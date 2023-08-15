class CreatePlainConversations < ActiveRecord::Migration[7.0]
  def change
    create_table :plain_conversations do |t|
      t.string :subject

      t.timestamps
    end
  end
end
