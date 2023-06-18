class AddColumnsToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :home, :string
    add_column :games, :away, :string
    add_column :games, :home_score, :string
    add_column :games, :away_score, :string
  end
end
