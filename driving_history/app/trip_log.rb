require_relative './trip'

class TripLog

  def self.parse log_line
    split_line = log_line.split
    parsed_log = {
      command: split_line.first,
      # We are going to assume the name is all of the values after the command.
      name:       get_name(split_line)
    }
    unless split_line[-3..].nil?
      parsed_log[:start_time] = split_line[-3..][0]
      parsed_log[:end_time]   = split_line[-3..][1]
      parsed_log[:distance]   = split_line[-3..][2]
    end
    parsed_log
  end


  def initialize(file_location)
    # Have a default file to read in.
    file_location ||= './data/initial_input.txt'
    @raw_file = File.read(file_location)
  end

  def all_commands
    @all_commands ||= @raw_file.split("\n")
    @all_commands
  end

  private

  def self.get_name split_line
    # If 1..-4 is empty this is likely a Driver command with only one argument
    return split_line[1..].join(' ') if split_line[1..-4].join(' ').empty?
    split_line[1..-4].join(' ')
  end
end