class AddNumberToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :number, :integer
  end
end
