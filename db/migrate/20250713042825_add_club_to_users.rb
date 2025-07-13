class AddClubToUsers < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :club, foreign_key: true
  end
end
