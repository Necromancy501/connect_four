class Player

  attr_reader :name

  def initialize name, board
    @name = name
    @board = board
  end

  def place_chip peg_char, column_index
    return if column_index >= Board::COLUMNS
    chip = Pegs.new peg_char
    height = @board.column_height column_index
    chip.address = [height, column_index]
    @board.last_move = @name
    @board.grid[height][column_index] = chip unless height == Board::ROWS
  end

end