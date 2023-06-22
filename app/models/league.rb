class League < ApplicationRecord
  has_many :teams, dependent: :destroy
  has_one_attached :photo
end
