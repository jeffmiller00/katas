#!/usr/bin/env ruby
require 'pry'
require_relative './config_mail.rb'

def send_results(xmas_list)
  email_body = "The Christmas pairs are...\n--------------------------------------------------------\n"
  xmas_list.each do |pair|
    email_body << "#{pair.first} buys for #{pair.last}\n"
  end

  # The mailing addresses are in config_mail.

  Mail.deliver do
    from send_from_address
    to   send_to_address
    subject 'Secret Santa Pairs -- Kids'
    body email_body
  end
end

def eligible_pair?(picker, pulled_name)
  # See config_mail section A
  return false if picker == pulled_name
  return false if inelibible_pairs.include?([picker,pulled_name].sort)
  true
end

# See config_mail section B

hat = xmas_pairs.keys.shuffle

while !hat.empty?
  hat = hat.shuffle
  picker = xmas_pairs.find{|k,v| v.nil?}.first
  pulled_name = hat.first
  # I know this isn't the only fail case, but it covers most of them.
  if hat.size == 1 && !eligible_pair?(picker, pulled_name)
    puts "Didn't work this time, try again!"
    exit!
  end
  if eligible_pair?(picker, pulled_name)
    xmas_pairs[picker] = pulled_name
    hat.delete_at(0)
    puts "Deleted............."
  end
end

# binding.pry
send_results(xmas_pairs)
puts "Done."