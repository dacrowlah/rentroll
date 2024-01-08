# frozen_string_literal: true
require 'pp'
class RentRollReport
  class << self
    def generate_for(report_date)

      rent_roll = {}
      data = RentRoll.all
      data.collect(&:unit)
          .uniq
          .sort
          .each { |k| rent_roll[k] = blank_unit_hash }

      data.each do |r|
        unit = rent_roll[r.unit]
        unit[:floor_plan] = r.floor_plan

        unless r.available_on report_date
          unit[:available] = false
          unit[:current_resident] = r.resident_data
        end

        if r.future_tenant? report_date
          unit[:future_residents].append(r.resident_data)
        end

        rent_roll[r.unit] = unit
      end

      occupied_units  = rent_roll.select {|_, v| !v[:available] }.count
      leased_units    = rent_roll.select {|_, v| unit_leased? v }.count
      vacant_units    = rent_roll.keys.count - leased_units

      {
        header: {
          report_date:    report_date,
          vacant_units:   vacant_units,
          occupied_units: occupied_units,
          leased_units:   leased_units
        },
        rent_roll: rent_roll
      }

    end

    # to maintain consistency with date format in the csv, use m/d/Y
    def generate_and_print_report_for(date)

      report_date = Date.strptime(date, "%m/%d/%Y")
      report      = generate_for report_date
      header      = report[:header]
      rent_roll   = report[:rent_roll]

      print_report_header header
      rent_roll.each do |unit_number, unit|
        print_unit_header unit_number, unit
        print_current_resident_section unit[:current_resident]
        print_future_residents_section unit[:future_residents]
        print_section_separator
      end

    end

    private
      def unit_leased?(v)
        v[:future_residents].present? || !v[:available]
      end

      def blank_unit_hash
        { available: true, floor_plan: nil, current_resident: {}, future_residents: [] }
      end

      def print_report_header(header)
        puts "===================================================="
        puts "RENT ROLL REPORT FOR:  #{ header[:report_date]    } "
        puts "VACANT UNITS:          #{ header[:vacant_units]   } "
        puts "OCCUPIED UNITS:        #{ header[:occupied_units] } "
        puts "LEASED UNITS:          #{ header[:leased_units]   } "
        puts "===================================================="
        print_section_separator
      end

      def print_unit_header(unit_number, unit)
        puts "Unit #{ unit_number } / Floor Plan: #{ unit[:floor_plan] } / Status: #{ status_of unit }"
      end

      def status_of(unit)
        case
        when unit[:future_residents].present? then "LEASED"
        when !unit[:available] then "OCCUPIED"
        else "VACANT"
        end
      end

      def print_future_residents_section(future_residents)
        if future_residents.blank?
          puts "Future Resident(s): NONE"
          return
        end

        puts "Future Resident(s):"
        future_residents.map { |r| print_resident r}
      end

      def print_current_resident_section(current_resident)
        if current_resident.blank?
          puts "Current Resident: NONE"
          return
        end

        puts "Current Resident:"
        print_resident current_resident
      end

      def print_resident(r)
        if r.blank?
          return
        end

        name      = r[:name].present?     ? "Name: #{ r[:name]}"            : ""
        move_in   = r[:move_in].present?  ? "Move In: #{ r[:move_in] }"     : ""
        move_out  = r[:move_out].present? ? "Move Out: #{ r[:move_out] }"   : ""

        puts "--> #{ name } #{ move_in } #{ move_out }"
      end

      def print_section_separator
        3.times { puts "" }
      end
  end

end
