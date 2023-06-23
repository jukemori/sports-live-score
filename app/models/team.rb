class Team < ApplicationRecord
  belongs_to :league
  has_one_attached :photo
  has_many :home_results, class_name: 'Result', foreign_key: 'home_team_id', dependent: :destroy
  has_many :away_results, class_name: 'Result', foreign_key: 'away_team_id', dependent: :destroy
end
