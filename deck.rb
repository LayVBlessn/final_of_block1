require_relative 'card'

class Deck
  attr_reader :deck

  def initialize
    @deck = deck_create
  end

  def take_card!
    card = self.deck[rand(deck.length)]
    deck.delete(card)
    card
  end

  private

  def deck_create
    deck = []
    ['♠', '♥', '♦', '♣'].each do |suit|
        [*(2..10), 'J','Q','K','A'].each do |rank|
          deck << Card.new(rank, suit)
        end
    end
    deck
  end

end
