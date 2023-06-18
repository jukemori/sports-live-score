class RemoveGameIdFromScores < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :scores, :game_id
  end
end
