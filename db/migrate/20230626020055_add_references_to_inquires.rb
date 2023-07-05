class AddReferencesToInquires < ActiveRecord::Migration[7.0]
  def change
    add_reference :inquires, :chat_session, null: false, foreign_key: true
  end
end
