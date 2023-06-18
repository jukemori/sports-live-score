class RemoveNameFromGames < ActiveRecord::Migration[7.0]
  def change
    remove_column :games, :name, :string
  end
end
