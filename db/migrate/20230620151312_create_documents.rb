class CreateDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :documents do |t|
      t.text :title
      t.jsonb :metadata, default: {}
      t.string :format

      t.timestamps
    end
  end
end
