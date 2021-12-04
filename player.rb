require_relative 'hand'

class User
  attr_reader :name, :balance, :hand

  def initialize(name)
    @name = name
    @balance = 100
    @hand = Hand.new
  end

  def card_number
    @hand.hand.length
  end

  def make_a_bet
    @balance -= 10
  end

  def take_bank(bank)
    @balance += bank
  end

  def take_card(card)
    @hand.add_card(card)
  end

  def skip_turn
    nil
  end

  def show_cards!
    @hand.hand= []
  end

end

class Diler < User
  def initialize
    super('Diler')
  end

  def take_card(card)
    @hand.add_card(card)
  end

  def skip_turn(card)
    nil
  end

end
