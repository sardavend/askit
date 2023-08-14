class AddMetadataToInquires < ActiveRecord::Migration[7.0]
  def change
    add_column :inquires, :metadata, :jsonb, default: {}
  end
end
