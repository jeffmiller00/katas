require_relative 'lib/game.rb'

attempts = 10000
wins = 0

attempts.times do
  game  = Game.new
  game.guess = Random.new.rand(game.doors.size)

  game.open_door!
  game.guess = game.switch_choice!
  game.open_door!
  wins = wins + 1 if game.winner?
end

puts "Winning percentage: #{(((wins*1.0)/attempts)*100).round(2)}%"
