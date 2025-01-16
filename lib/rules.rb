class Rules

  def initialize board
    @board = board
  end

  def game_over?
    !winner.nil? || tie?
  end

  def tie?
    @board.grid.flatten.compact == @board.grid.flatten
  end

  def winner
    current_game = @board.grid
  
    current_game.each do |row|
      row.each do |chip|
        next if chip.nil? # Skip empty slots
        return @board.last_move if sequence?(chip, current_game) # Return winner
      end
    end
  
    nil # No winner found
  end
  

  def sequence?(peg_obj, grid, count = 1, direction = nil)
    return true if count == 4 # Base case: winning sequence found
  
    y, x = peg_obj.address
  
    # Define neighbors
    neighbours = {
      up_neighbour: grid.dig(y + 1, x),
      upleft_neighbour: grid.dig(y + 1, x - 1),
      upright_neighbour: grid.dig(y + 1, x + 1),
      right_neighbour: grid.dig(y, x + 1)
    }
  
    if direction # Continue in the current direction
      next_obj = neighbours[direction]
      return sequence?(next_obj, grid, count + 1, direction) if next_obj&.chip == peg_obj.chip
    else # Explore all directions from the current chip
      neighbours.each do |dir, neighbor|
        next unless neighbor&.chip == peg_obj.chip # Skip mismatched or nil neighbors
        return true if sequence?(neighbor, grid, count + 1, dir) # Winning sequence detected
      end
    end
  
    false # No winning sequence in this path
  end  

end