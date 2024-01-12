# frozen_string_literal: true
require 'test_helper'

class RentRollReportLineItemTest < ActiveSupport::TestCase
  test "that nil report_date argument to constructor raises error" do
    assert_raise RuntimeError do
      RentRollReportLineItem.new(report_date: nil, rent_rolls:[])
    end
  end

  test "that empty list to constructor raises error" do
    assert_raise RuntimeError do
      RentRollReportLineItem.new(report_date: today, rent_rolls: [])
    end
  end

  test "that listing containing data for more than 1 unit raises error" do
    data = [RentRoll.new(unit: 1), RentRoll.new(unit: 2)]
    assert_raise RuntimeError do
      RentRollReportLineItem.new(report_date: today, rent_rolls: data)
    end
  end

  test "that list containing data for only one unit does not raise error" do
    data = [RentRoll.new(unit: 1), RentRoll.new(unit: 1)]
    assert_nothing_raised do
      RentRollReportLineItem.new(report_date: today, rent_rolls: data)
    end
  end

  test "that rent roll with future move in date counts as future resident" do
    item = RentRollReportLineItem.new(report_date: today, rent_rolls: [RentRoll.new(move_in: next_year)])
    assert item.leased?
    assert item.leased_or_occupied?
    assert_not item.vacant?
    assert_equal UnitStatus::LEASED, item.status
  end

  test "that rent roll with move in and move out spanning report date is occupied" do
    rent_rolls = [RentRoll.new(move_in: yesterday, move_out: tomorrow)]
    item = RentRollReportLineItem.new(report_date: today, rent_rolls: rent_rolls)
    assert item.occupied?
    assert_not item.vacant?
    assert_equal UnitStatus::OCCUPIED, item.status
  end

  test "that rent roll with no move in or move out is vacant" do
    item = RentRollReportLineItem.new(report_date: today, rent_rolls: [RentRoll.new(move_in: nil)])
    assert item.vacant?
    assert_not item.leased_or_occupied?
    assert UnitStatus::VACANT, item.status
  end

  test "that unit number and floor plan are displayed correctly" do
    rent_roll = RentRoll.new(unit: 1, floor_plan: FloorPlans::STUDIO)
    item = RentRollReportLineItem.new(report_date: today, rent_rolls: [rent_roll])
    assert_equal 1, item.unit
    assert_equal FloorPlans::STUDIO, item.floor_plan
  end

  test "that rent roll with move out date in the past is vacant" do
    rent_rolls = [RentRoll.new(move_in: yesterday, move_out: tomorrow)]
    item = RentRollReportLineItem.new(report_date: day_after_tomorrow, rent_rolls: rent_rolls)
    assert item.vacant?
    assert_not item.leased_or_occupied?
    assert_equal UnitStatus::VACANT, item.status
  end
end
