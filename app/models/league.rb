class League < ApplicationRecord
  has_many :teams
  has_one_attached :photo
end
