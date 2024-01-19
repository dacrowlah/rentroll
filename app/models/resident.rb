class Resident < ApplicationRecord
  validates :name, presence: true
  validates_uniqueness_of :name
  has_many :rent_rolls
end
