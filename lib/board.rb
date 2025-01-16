class Board

  attr_accessor :grid , :last_move

  ROWS = 6
  COLUMNS = 7

  def initialize
    @grid = Array.new(ROWS) { Array.new(COLUMNS) }
    @last_move = ''
  end

  def to_s
    board_copy = @grid.dup.reverse
    display_str = ''
    board_copy.each do |row|
      row.each do |peg|
        display_str += peg.nil? ? '❘ ❘' : "❘#{peg.chip}❘"
      end
      display_str += "\n"
    end
    display_str
  end

  def column_height index_column
    column = self.get_column index_column
    column.count { |chip| !chip.nil? }
  end

  def get_column index_column
    @grid.reduce(Array.new) do |column, row|
      column << row[index_column]
    end
  end

end