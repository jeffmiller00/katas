require 'time'

class Trip
  attr_reader :distance

  def initialize start_time, end_time, distance
    @start_time = Time.parse(start_time)
    @end_time = Time.parse(end_time)
    @distance = distance.to_f
    validate_speed
  end

  def length
    @trip_time ||= (@end_time - @start_time) / 60 / 60
    @trip_time
  end

  def miles_per_hour
    @trip_speed ||= @distance / self.length
    @trip_speed
  end

private

  def validate_speed
    raise ArgumentError, 'Start time not before end time.' if @start_time > @end_time
    raise ArgumentError, 'Speed too slow' if self.miles_per_hour < 5
    raise ArgumentError, 'Speed too fast' if self.miles_per_hour > 100
  end
end