class AddDescriptionToClubs < ActiveRecord::Migration[7.1]
  def change
    add_column :clubs, :description, :text
  end
end
