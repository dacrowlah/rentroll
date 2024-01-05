require "test_helper"

class RentRollTest < ActiveSupport::TestCase
  TODAY               = Date.today
  YESTERDAY           = TODAY - 1.day
  TOMORROW            = TODAY + 1.day
  DAY_AFTER_TOMORROW  = TOMORROW + 1.day

  test "the unit is available with no move in or move out date set" do 
    roll = RentRoll.new
    assert roll.available_on(TODAY)
  end

  test "the unit is available for date after move_out date" do 
    roll = RentRoll.new
    roll.move_in = YESTERDAY
    roll.move_out = TOMORROW
    assert roll.available_on(DAY_AFTER_TOMORROW)
  end

  test "the unit is not available for date within range of move_in/move_out" do 
    roll = RentRoll.new
    roll.move_in = YESTERDAY
    roll.move_out = TOMORROW
    assert_not roll.available_on(TODAY)
  end

  test "the unit is not available for date after move_in without move_out date set" do 
    roll = RentRoll.new
    roll.move_in = YESTERDAY
    assert_not roll.available_on(TODAY)
  end
end
