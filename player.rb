class User

  attr_reader :name, :hand, :balance

  def initialize(name)
    @name = name
    @balance = 100
    @hand = []
  end

  def card_number
    self.hand.length
  end

  def make_a_bet
    @balance -= 10
  end

  def take_bank(bank)
    @balance += bank
  end

  def take_card(card)
    @hand << card if @hand.length != 3
  end

  def scores
    sum = 0
    hand.each do |card|
      if ['J', 'Q', 'K'].include?(card.rank)
        sum += 10
      elsif card.rank == 'A'
        sum+11 <= 21 ? sum +=11 : sum += 1
      elsif card.rank.is_a?(Integer)
        sum += card.rank.to_i
      end
    end
    sum
  end

  def skip_turn
    nil
  end

  def show_cards!
    self.hand= []
  end

  protected

  attr_writer :hand

end

class Diler < User
  def initialize
    super('Diler')
  end

  def take_card(card)
    @hand << card if scores <= 17 and @hand.length!=3
  end

  def skip_turn
    nil
  end

end
