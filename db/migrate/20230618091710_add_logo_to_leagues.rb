class AddLogoToLeagues < ActiveRecord::Migration[7.0]
  def change
    add_column :leagues, :logo, :string
  end
end
