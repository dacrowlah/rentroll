namespace :tasks do
  require 'csv'

  desc "reloads csv data"
  task :reload_csv_data => :environment do |t, arg|
    Resident.delete_all
    RentRoll.delete_all

    CSV.foreach('lib/datasets/units-and-residents.csv', :headers => true) do |row|
      params  = row.to_hash
      name    = params["resident"]

      unless name.present?
        RentRoll.create!(params.except("resident"))
        next
      end

      resident = Resident.find_or_create_by! name: name
      resident.rent_rolls.create! params.except("resident")
    end
  end
end