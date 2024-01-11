# frozen_string_literal: true

class RentRollReportLineItem
  def initialize(report_date: nil, rent_rolls: [])
    if rent_rolls.empty?
      raise "argument rent_rolls contains no data"
    end

    if rent_rolls.collect(&:unit).uniq.count > 1
      raise "argument rent_rolls must contain data for only one unit"
    end

    first_unit        = rent_rolls.first
    @future_residents = []
    @unit             = first_unit.unit
    @floor_plan       = first_unit.floor_plan

    rent_rolls.each do |r|
      if r.future_resident? report_date
        @future_residents.append r
      end

      if r.not_available_on? report_date
        @current_resident = r
      end
    end

    if @future_residents.present?
      @future_residents.sort_by! &:move_in_date
    end
  end

  def report_section
    puts "Unit: #{ @unit }  - Floor Plan: #{ @floor_plan } - Status: #{ status }"

    if @current_resident.present?
      puts print_resident ResidentStatus::CURRENT, @current_resident
    end

    @future_residents.each do |future_resident|
      puts print_resident ResidentStatus::FUTURE, future_resident
    end

    puts "---------------------------------------------------------------------------------------------------"
  end

  def unit
    @unit
  end

  def floor_plan
    @floor_plan
  end

  def leased?
    @future_residents.present?
  end

  def occupied?
    !@current_resident.nil?
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
  def print_resident(resident_status, r)
    move_out = r.move_out.present? ? "- Move Out: #{ r.move_out }" : ""
    "--> Resident Status: #{ resident_status } Name: #{ r.resident } - Move In: #{ r.move_in } #{ move_out }"
  end
end
