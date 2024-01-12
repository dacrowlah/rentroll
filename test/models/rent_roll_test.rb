require "test_helper"

class RentRollTest < ActiveSupport::TestCase
  test "the unit is available with no move in or move out date set" do
    roll = RentRoll.new
    assert roll.vacant_on?(today)
  end

  test "the unit is available for date after move_out date" do 
    roll = RentRoll.new(:move_in => yesterday, :move_out => tomorrow)
    assert roll.vacant_on?(day_after_tomorrow)
  end

  test "the unit is not available for date within range of move_in/move_out" do 
    roll = RentRoll.new(:move_in => yesterday, :move_out => tomorrow)
    assert_not roll.vacant_on?(today)
  end

  test "the unit is not available for date after move_in without move_out date set" do 
    roll = RentRoll.new(:move_in => yesterday)
    assert_not roll.vacant_on?(today)
  end

  test "the unit is available now, but has a tenant with a future move in date" do
    roll = RentRoll.new(move_in: tomorrow)
    assert roll.vacant_on?(today)
    assert roll.future_resident? today
  end

  test "the unit is occupied and does not have a future tenant" do
    roll = RentRoll.new(move_in: yesterday)
    assert_not roll.vacant_on? today
    assert_not roll.future_resident? today
  end
end
