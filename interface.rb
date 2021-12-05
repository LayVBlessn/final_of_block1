require_relative 'logic'

class Interface

  def initialize()
    @obj = Logic.new(self.ask_player_name)
    @interface = lambda do |player, diler|
      puts "#{'='*5} Дилер #{'='*5}"
      puts "Карты: #{'*'*diler.card_number}"
      puts "#{'='*5} #{player.name} #{'='*5}"
      puts "Карты: #{player.hand.hand.map{|card| "#{card.rank}#{card.suit}"}.join(' ,')}"
      puts "Очки: #{player.hand.scores}"
      puts "Баланс: #{player.balance}"
      puts '='*15
    end
  end

  def start
    print_info
    loop do
      @obj.free_hands
      @obj.hand_out_cards
      @obj.set_bank
      if @obj.check_end_of_the_game_extern
        loop do
          if @obj.len_check
            break  if !@obj.check_end_of_the_game
          else
            break if !@obj.player_turn(@interface)
            break if !@obj.diler_turn(@interface)
          end
        end
      end
      break if play_next_game?
    end
    goodbye
  end

  def ask_player_name
    puts 'Здравствуйте! Представьтесь и начнем игру!'
    print 'Введите Ваше имя: '
    @name = gets.chomp
  end

  def play_next_game?
    puts "Хотите сыграть еще раз?
1. Да
2. Нет"
    print 'Ваш выбор: '
    choice = gets.chomp.to_i
    case choice
    when 1
      false
    when 2
      true
    end
  end

  def print_info
    puts 'На данный момент у Вас и у Диллера в банке по $100.'
    puts 'Ваша задача набрать 21 очко, либо ближайшеие к 21 очки'
    puts 'Вы проиграете, если у вас на руке будет больше 21. Удачи!'
  end

  def goodbye
    puts "До свидания, #{@name}!"
  end

end
