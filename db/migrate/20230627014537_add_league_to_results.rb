class AddLeagueToResults < ActiveRecord::Migration[7.0]
  def change
    add_column :results, :league, :string
  end
end
