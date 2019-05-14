class AddUserToPhrases < ActiveRecord::Migration[6.0]
  def change
    add_reference :phrases, :user, null: false, foreign_key: true
  end
end
