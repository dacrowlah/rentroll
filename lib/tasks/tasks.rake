namespace :tasks do
  require 'csv'

  desc "reloads csv data"
  task :reload_csv_data => :environment do |t, arg|
    RentRoll.delete_all

    CSV.foreach('lib/datasets/units-and-residents.csv', :headers => true) do |row|
      RentRoll.create(row.to_hash)
    end
  end
end