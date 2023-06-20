class CreatePages < ActiveRecord::Migration[7.0]
  def change
    create_table :pages do |t|
      t.integer :num
      t.text :content
      t.references :document, null: false, foreign_key: true
      t.vector :embedding, limit: 1536

      t.timestamps
    end
  end
end
