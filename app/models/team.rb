class Team < ApplicationRecord
  belongs_to :league
  has_one_attached :photo
end
