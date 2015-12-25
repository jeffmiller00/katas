class Door
  attr_accessor :prize, :state

  def initialize what_is_inside=:goat
    @prize = what_is_inside
    @state = :closed
  end

  def self.create_winner
    Door.new :car
  end

  def winner?
    @prize == :car
  end

  def loser?
    !self.winner?
  end

  def open?
    @state == :open
  end

  def closed?
    !self.open?
  end

  def open!
    raise(AlreadyOpen, 'That door is already opened!') if (@state == :open)
    @state = :open
    @prize
  end
end