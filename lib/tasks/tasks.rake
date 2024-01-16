namespace :tasks do
  require 'csv'

  desc "reloads csv data"
  task :reload_csv_data => :environment do |t, arg|
    Resident.delete_all
    RentRoll.delete_all


    CSV.foreach('lib/datasets/units-and-residents.csv', :headers => true) do |row|
      data = row.to_hash

      if data["ssn"].present?
        resident = Resident.find_by(ssn: data["ssn"])
        if resident.nil?
          resident_hash = {
            name: data["resident"],
            ssn: data["ssn"]
          }
          resident = Resident.create(resident_hash)
        end

        data["resident_id"] = resident.id
      end

      RentRoll.create!(data.except("resident", "ssn"))
    end
  end
end