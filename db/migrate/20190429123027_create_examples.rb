class CreateExamples < ActiveRecord::Migration[6.0]
  def change
    create_table :examples do |t|
      t.string :example
      t.integer :user_id
      t.integer :phrase_id

      t.timestamps
    end
  end
end
