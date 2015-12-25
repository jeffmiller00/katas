require_relative './door'

class Game
  attr_accessor :num_doors, :doors, :style, :player_strategy, :guess

  def initialize number_of_doors = 3, game_style = :classic
    @style = game_style == :random ? :random : :classic
    @player_strategy = :no_switch # :switch or :no_switch
    @doors = []
    @num_doors = [2,number_of_doors].max
    @doors << Door.create_winner
    (@num_doors-1).times do
      @doors << Door.new
    end
    @doors.shuffle!
    self
  end

  def winner?
    return false unless remaining_closed_indexes.size == 1
    @doors[@guess].winner? && @doors[@guess].closed?
  end

  def all_doors_open?
    remaining_closed_indexes.empty?
  end

  def open_door!
    raise RuntimeError, 'You haven\'t made a guess!' if @guess.nil?
    raise RuntimeError, 'All the doors are open!' if all_doors_open?

    if @style == :classic
      open_losing_door!
    elsif @style == :random
      open_random_door!
    else
      raise RuntimeError, 'I don\'t know what style you are trying to play!'
    end

    @doors
  end

  def switch_choice!
    return @guess if player_strategy == :no_switch

    closed_indexes = remaining_closed_indexes
    closed_indexes.delete(@guess)
    @guess = closed_indexes.sample
  end


  protected


  def remaining_losing_indexes
    @doors.each_with_index.map{ |d,i| i if d.closed? && d.loser?}.compact
  end


  private


  def remaining_closed_indexes
    @doors.each_with_index.map{ |d,i| i if d.closed?}.compact
  end

  def open_losing_door!
    return if self.remaining_losing_indexes.empty?
    @doors[remaining_losing_indexes.sample].open!
  end
end