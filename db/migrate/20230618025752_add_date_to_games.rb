class AddDateToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :date, :datetime
  end
end