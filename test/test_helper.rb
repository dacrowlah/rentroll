ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def today
      Date.today
    end

    def yesterday
      (today - 1.day).strftime(Constants::DATE_FORMAT)
    end

    def tomorrow
      (today + 1.day).strftime(Constants::DATE_FORMAT)
    end

    def day_after_tomorrow
      today + 2.days
    end

    def next_year
      (today + 1.year).strftime(Constants::DATE_FORMAT)
    end
  end
end
