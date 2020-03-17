require_relative './trip'

class Driver
  @@all_drivers = []

  def self.find driver_name
    @@all_drivers.select{ |driver| driver.full_name == driver_name }.first
  end

  def self.create! driver_name
    new_driver = Driver.new(driver_name)
    @@all_drivers << new_driver
    new_driver
  end

  def self.sort_by_total_distance!
    @@all_drivers = @@all_drivers.sort_by(&:total_distance).reverse
  end

  def self.print_all
    @@all_drivers.each do |driver|
      puts driver.to_s
    end
  end


  attr_reader :full_name, :trips

  def initialize driver_name
    @full_name = driver_name
    @trips = []
  end

  def add_trip new_trip
    @trips << new_trip
  end

  def total_distance
    @trips.collect(&:distance).inject(:+).to_f
  end

  def total_length
    @trips.collect(&:length).inject(:+).to_f
  end

  def average_speed
    return nil if @trips.empty?
    self.total_distance / self.total_length
  end

  def to_s
    output_string = "#{@full_name}: #{self.total_distance.round} miles"
    output_string << " @ #{self.average_speed.round} mph" if average_speed
    output_string
  end
end