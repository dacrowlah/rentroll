# README

To run this:
- run database migrations
- run the rake task to load the data `rake tasks:reload_csv_data`
- open rails console
- at the rails console prompt run `RentRollReport.run_for("5/30/2019")` changing out the date as necessary
- Note: I used the %m/%d/%Y format because that's what matches the csv data, and wasn't sure if it was a preferred format.
- there are 3 rake tasks that can be used to load/clear/reload in one step all of the csv data.

