class RentRoll < ApplicationRecord
  def available_on(report_date)
    case
      when has_move_in_with_no_move_out?  then report_date < move_in_date
      when has_move_in_and_move_out?      then is_date_available_to_rent? report_date
      else true
    end
  end

  private
    ##############################################################################
    # didn't realize till after i started that sqlite doesn't have a proper      #
    # datetime column data type, move_in is the column (string) and move_in_date #
    # is the parsed version for comparison, same with move_out                   #
    ##############################################################################
    def has_move_in_with_no_move_out?
      move_in.present? && !move_out.present?
    end

    def has_move_in_and_move_out?
      move_in.present? && move_out.present?
    end

    def is_date_available_to_rent?(report_date)
      !rented_dates.include? report_date
    end

    def move_in_date
      Date.strptime(move_in, '%m/%d/%Y')
    end

    def move_out_date
      Date.strptime(move_out, '%m/%d/%Y')
    end

    def rented_dates
      move_in_date..move_out_date
    end
end
