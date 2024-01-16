# frozen_string_literal: true

class RentRollReportLineItem
  def initialize(report_date: nil, rent_rolls: [])
    verify_args(report_date, rent_rolls: rent_rolls)
    @current_unit       = rent_rolls.first
    @future_residents   = rent_rolls.select { |r| r.future_resident? report_date }
    @current_residents  = rent_rolls.select { |r| r.occupied_on? report_date }

    @current_residents.sort_by! &:move_in_date
    @future_residents.sort_by! &:move_in_date
  end

  def report_section
    puts "Unit: #{ @unit }  - Floor Plan: #{ @floor_plan } - Status: #{ status }"
    print_residents ResidentStatus::CURRENT, residents: @current_residents
    print_residents ResidentStatus::FUTURE, residents: @future_residents
    puts "---------------------------------------------------------------------------------------------------"
  end

  def unit
    @unit ||= @current_unit.present? ? @current_unit.unit : "N/A"
  end

  def floor_plan
    @floor_plan ||= @current_unit.present? ? @current_unit.floor_plan : "N/A"
  end

  def leased?
    @future_residents.present?
  end

  def occupied?
    @current_residents.present?
  end

  def vacant?
    !leased_or_occupied?
  end

  def leased_or_occupied?
    leased? || occupied?
  end

  def status
    case
    when occupied? then UnitStatus::OCCUPIED
    when leased? then UnitStatus::LEASED
    else UnitStatus::VACANT
    end
  end

  private
  def print_residents(status, residents: [])
    residents.each { |r| print_resident status, r }
  end

  def print_resident(resident_status, r)
    move_out = r.move_out.present? ? "- Move Out: #{ r.move_out }" : ""
    puts "--> Resident Status: #{ resident_status } Name: #{ r.resident_name } - Move In: #{ r.move_in } #{ move_out }"
  end

  def verify_args(report_date, rent_rolls: [])
    if report_date.nil?
      raise "argument report_date cannot be nil"
    end

    if rent_rolls.empty?
      raise "argument rent_rolls contains no data"
    end

    if rent_rolls.collect(&:unit).uniq.count > 1
      raise "argument rent_rolls must contain data for only one unit"
    end
  end
end
