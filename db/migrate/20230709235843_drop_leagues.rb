class DropLeagues < ActiveRecord::Migration[7.0]
  def change
    drop_table :leagues
  end
end
