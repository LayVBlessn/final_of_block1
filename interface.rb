require_relative 'logic'

class Interface
  include Logic

  def initialize
    obj = create
    @player = obj[0]
    @diler = obj[1]
    @bank = 0
  end

  def start
    print_info
    loop do
      free_hands
      hand_out_cards
      set_bank
      if check_end_of_the_game_extern
        loop do
          if len_check
            break  if !check_end_of_the_game
          else
            break if !player_turn
            break if !diler_turn
          end
        end
      end
      break if play_next_game?
    end
    goodbye
  end

end
