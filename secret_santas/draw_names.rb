#!/usr/bin/env ruby
require 'pry'
require_relative './config_mail.rb'

def send_results(xmas_list)
  email_body = "The Christmas pairs are...\n--------------------------------------------------------\n"
  xmas_list.each do |pair|
    email_body << "#{pair.first} buys for #{pair.last}\n"
  end

  Mail.deliver do
    from 'jeffmiller00@gmail.com'
    to   'Mom <Colleenamiller14@gmail.com>, Dad <mbeltd@aim.com>'
    # to   'jeffmiller00@gmail.com'
    subject 'Secret Santa Pairs -- Kids'
    body email_body
  end
end

def eligible_pair?(picker, pulled_name)
  # inelibible_pairs = [['Jeff','Krista'],['Greg','Shaunda'],['Jenna','Tim'],['Talere','Zach']]
  inelibible_pairs = [['Lauren','Vince'],['Carter','Hallie'],['Evelyn','Miles']]
  return false if picker == pulled_name
  return false if inelibible_pairs.include?([picker,pulled_name].sort)
  true
end

# Adults
xmas_pairs = {
  'Jeff' => nil,
  'Krista' => nil,
  'Greg' => nil,
  'Shaunda' => nil,
  'Tim' => nil,
  'Jenna' => nil,
  'Zach' => nil,
  'Talere' => nil
}
# Kids
xmas_pairs = {
  'Vince' => nil,
  'Lauren' => nil,
  'Hallie' => nil,
  'Carter' => nil,
  'Miles' => nil,
  'Evelyn' => nil
}

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