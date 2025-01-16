require_relative 'lib/rainbow_helper'
require_relative 'lib/rules.rb'
require_relative 'lib/pegs.rb'
require_relative 'lib/board.rb'
require_relative 'lib/player.rb'

class Game

  def initialize player_1, player_2
    @board = Board.new
    @players = [Player.new(player_1, @board), Player.new(player_2, @board)]
    @rules = Rules.new @board
  end

  def round
    turn = 0
    until @rules.game_over? do
      current_player = @players[turn%2]
      puts "#{current_player.name}, please select a color\n", "Colors Available:\n", "Y: Yellow\n", "R: Red\n", "B: Blue\n", "G: Green\n"
      color = gets.chomp.downcase
      puts "#{current_player.name}, please select a column number from 1 to 7\n"
      column = gets.chomp.to_i
      current_player.place_chip color, column - 1
      puts @board
      turn += 1
    end

    puts @rules.tie? ? "Tie! Neither player wins." : "#{@board.last_move} wins!"
  end
end