require 'csv'

class RentRoll < ApplicationRecord
  attr :unit, :floor_plan, :resident, :move_in, :move_out
end
