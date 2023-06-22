class CreateInquires < ActiveRecord::Migration[7.0]
  def change
    create_table :inquires do |t|
      t.text :question
      t.text :answer

      t.timestamps
    end
  end
end
