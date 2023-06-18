class League < ApplicationRecord
  has_many :games, dependent: :destroy
end
