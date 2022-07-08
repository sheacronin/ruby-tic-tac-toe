# frozen_string_literal: true

# Controls the flow of the tic-tac-toe game
class Game
  def set_up
    @board = GameBoard.new
    puts 'Welcome to Tic-Tac-Toe!'
    puts "What is Player 1's name? They will be X"
    p1_name = gets.chomp
    @player1 = Player.new(p1_name, 'X', @board)
    puts "What is Player 2's name? They will be O"
    p2_name = gets.chomp
    @player2 = Player.new(p2_name, 'O', @board)
    @whose_turn = @player1
    play_round
  end

  def play_round
    coords = prompt_for_coords
    coords_valid = validate_coords(coords)
    return play_round unless coords_valid

    did_mark = @whose_turn.place_marker(coords)
    return play_round unless did_mark

    @board.show
    game_over? ? play_again : play_round
  end

  private

  def validate_coords(coords)
    row, col = coords.split('')
    unless coords.length == 2
      puts 'Type the coordinates with no spaces like: A1'
      return false
    end
    validate_row_coord(row) && validate_col_coord(col)
  end

  def validate_row_coord(row_coord)
    unless %w[A B C].include?(row_coord)
      puts 'Please enter a valid uppercase letter A-C as the first coordinate.'
      return false
    end
    true
  end

  def validate_col_coord(col_coord)
    unless col_coord.to_i.between?(1, 3)
      puts 'Please type in a valid number 1-3 as the second coordinate'
      return false
    end
    true
  end

  def play_again
    puts 'Play again? y / n'
    play_again = gets.chomp
    play_again == 'y' ? set_up : nil
  end

  def prompt_for_coords
    puts "It's #{@whose_turn.name}'s turn!"
    @board.show
    puts "#{@whose_turn.name}, where would you like to mark the board?"
    gets.chomp
  end

  def game_over?
    if @board.win?(@whose_turn.marker)
      puts "Game over! #{@whose_turn.name} wins!"
      true
    elsif @board.tie?
      puts "Game over! It's a tie."
      true
    else
      @whose_turn = @whose_turn == @player1 ? @player2 : @player1
      false
    end
  end
end

# Keeps track of the values on the tic-tac-toe game board
class GameBoard
  def initialize
    @board_values = [%w[_ _ _],
                     %w[_ _ _],
                     [' ', ' ', ' ']]
    @translate_rows_values = { 'A' => 0, 'B' => 1, 'C' => 2 }
  end

  def mark(coords, marker)
    translated_coords = translate_coords(coords)
    spot_empty = spot_empty?(@board_values[translated_coords[0]][translated_coords[1]])
    unless spot_empty
      puts 'This spot is already filled!'
      return false
    end
    @board_values[translated_coords[0]][translated_coords[1]] = marker
    true
  end

  def show
    puts '  1 2 3'
    puts "A #{@board_values[0].join('|')}"
    puts "B #{@board_values[1].join('|')}"
    puts "C #{@board_values[2].join('|')}"
  end

  def win?(marker)
    row_win?(marker) || column_win?(marker) || diagonal_win?(marker)
  end

  def tie?
    @board_values.each do |row|
      row.each do |spot|
        return false if spot_empty?(spot)
      end
    end
    true
  end

  private

  def translate_coords(coords)
    row, col = coords.split('')
    [@translate_rows_values[row], col.to_i - 1]
  end

  def spot_empty?(spot)
    [' ', '_'].include?(spot)
  end

  def row_win?(marker)
    @board_values.each do |row|
      return true if row.all?(marker)
    end
    false
  end

  def column_win?(marker)
    3.times do |i|
      if @board_values[0][i] == marker &&
         @board_values[1][i] == marker &&
         @board_values[2][i] == marker
        return true
      end
    end

    false
  end

  def diagonal_win?(marker)
    # check diagonals
    if @board_values[0][0] == marker &&
       @board_values[1][1] == marker &&
       @board_values[2][2] == marker
      return true
    elsif @board_values[0][2] == marker &&
          @board_values[1][1] == marker &&
          @board_values[2][0] == marker
      return true
    end

    false
  end
end

# Contains the player information as well as the board they are playing on
class Player
  attr_reader :marker, :name

  def initialize(name, marker, game_board)
    @name = name
    @marker = marker
    @game_board = game_board
  end

  def place_marker(coords)
    @game_board.mark(coords, @marker)
  end
end

game = Game.new
game.set_up
