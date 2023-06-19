class AddEmbeddeingColumnToInquires < ActiveRecord::Migration[7.0]
  def change
    add_column :inquires, :embedding, :vector, limit: 1536
  end
end
