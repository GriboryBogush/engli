class AddReadToActivities < ActiveRecord::Migration[6.0]
  def change
    add_column :activities, :read, :boolean, default: false
  end
end
