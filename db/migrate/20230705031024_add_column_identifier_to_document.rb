class AddColumnIdentifierToDocument < ActiveRecord::Migration[7.0]
  def up
    add_column :document_pages, :identifier, :string

    DocumentPage.update_all("identifier=num")

    remove_column :document_pages, :num
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
