namespace :tasks do
  require 'csv'

  desc "load units and residents"
  task :load_csv_data => :environment do |t, arg|
    CSV.foreach('lib/datasets/units-and-residents.csv', :headers => true) do |row|
      RentRoll.create(row.to_hash)
    end
  end 

  desc "removes existing data"
  task :delete_csv_data => :environment do |t, arg|
  	RentRoll.delete_all
  end

  desc "reloads csv data"
  task :reload_csv_data => :environment do |t, arg|
	RentRoll.delete_all

	CSV.foreach('lib/datasets/units-and-residents.csv', :headers => true) do |row|
	  RentRoll.create(row.to_hash)
    end
  end
end