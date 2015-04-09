class Player
end

class Human < Player
  def choose_a_spot
    begin
      puts "Pick a square from 1-9."
      spot_selection = gets.chomp
    end until %w(1 2 3 4 5 6 7 8 9).include?(spot_selection)
    spot_selection.to_i
  end
end

class Computer < Player
  def choose_a_spot
  end
end

class Board
  attr_accessor :grid_spots
  attr_reader :remaining_empty_spots

  def initialize
    @grid_spots = []
    @remaining_empty_spots = []
    0..9.times do |time|
      grid_spots[time] = " "
      remaining_empty_spots << time
    end
  end

  def draw_board
    system 'clear'
    puts "       |       |       "
    puts "   #{grid_spots[1]}   |   #{grid_spots[2]}   |   #{grid_spots[3]}   "
    puts "       |       |       "
    puts "-----------------------"
    puts "       |       |       "
    puts "   #{grid_spots[4]}   |   #{grid_spots[5]}   |   #{grid_spots[6]}   "
    puts "       |       |       "
    puts "-----------------------"
    puts "       |       |       "
    puts "   #{grid_spots[7]}   |   #{grid_spots[8]}   |   #{grid_spots[9]}   "
    puts "       |       |       "
  end
end

class Game
  attr_accessor :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Human.new
    @computer = Computer.new
  end

  def play
    board.draw_board
    puts "Welcome to Tic-Tac-Toe!"
    board.grid_spots[(human.choose_a_spot).to_i] = 'X'
    board.draw_board
    #computer.choose_a_spot
  end

end

ttt = Game.new.play