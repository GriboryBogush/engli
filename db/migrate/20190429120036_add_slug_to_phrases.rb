class AddSlugToPhrases < ActiveRecord::Migration[6.0]
  def change
    add_column :phrases, :slug, :string
    add_index :phrases, :slug, unique: true
  end
end
