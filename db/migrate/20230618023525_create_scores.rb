class CreateScores < ActiveRecord::Migration[7.0]
  def change
    create_table :scores do |t|
      t.references :game, null: false, foreign_key: true
      t.string :home_team
      t.string :away_team
      t.string :home_score
      t.string :away_score
      t.datetime :date

      t.timestamps
    end
  end
end
