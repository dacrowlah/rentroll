namespace :tasks do
  require 'csv'

  desc "reloads csv data"
  task :reload_csv_data => :environment do |t, arg|
    Resident.delete_all
    RentRoll.delete_all


    CSV.foreach('lib/datasets/units-and-residents.csv', :headers => true) do |row|
      data = row.to_hash

      if data["resident"].present?
        resident = Resident.find_or_create_by! name: data["resident"]
        data["resident_id"] = resident.id
      end

      RentRoll.create!(data.except("resident"))
    end
  end
end