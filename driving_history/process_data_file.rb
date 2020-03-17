require_relative 'app/trip_log'
require_relative 'app/driver'


@filename = ARGV[0]
trip_log = TripLog.new @filename

trip_log.all_commands.each do |line|
  log = TripLog.parse(line)

  case log[:command]
  when 'Driver'
    Driver.create!(log[:name])
  when 'Trip'
    driver = Driver.find(log[:name])
    raise ArgumentError.new('Driver not found!') if driver.nil?
    driver.add_trip(Trip.new(log[:start_time],log[:end_time],log[:distance]))
  else
    raise StandardError.new("Unknown command: #{log[:command]}")
  end
end

Driver.sort_by_total_distance!
Driver.print_all