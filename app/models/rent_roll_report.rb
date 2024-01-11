# frozen_string_literal: true

class RentRollReport
  def self.run_for(date)
    report_date = Date.strptime date, "%m/%d/%Y"
    data        = RentRoll.all.group_by { |r| r.unit }
    line_items  = []

    data.each do |_, rent_rolls|
      line_items.append RentRollReportLineItem.new(
        report_date: report_date,
        rent_rolls: rent_rolls
      )
    end

    vacant_units    = line_items.select { |l| l.vacant? }.count
    occupied_units  = line_items.select { |l| l.occupied? }.count
    leased_units    = line_items.select { |l| l.leased_or_occupied? }.count

    puts "===================================================="
    puts "RENT ROLL REPORT FOR:  #{ report_date    }          "
    puts "VACANT UNITS:          #{ vacant_units   }          "
    puts "OCCUPIED UNITS:        #{ occupied_units }          "
    puts "LEASED UNITS:          #{ leased_units   }          "
    puts "===================================================="

    line_items.sort_by! { |l| l.unit }
    line_items.each(&:report_section)

  end
end
