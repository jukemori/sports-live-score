class AddHomePicAndAwayPicToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :home_pic, :string
    add_column :games, :away_pic, :string
  end
end
