class AddCategoryToPhrases < ActiveRecord::Migration[6.0]
  def change
    add_column :phrases, :category, :integer, default: 0
  end
end
