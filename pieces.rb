
class Piece

  def initialize(position, board, color)
    @board = board
    @position = position
    @color = color
  end

  attr_reader  :color, :board
  attr_accessor :position


  def empty?
    false
  end

  def valid_moves
    all_moves = self.moves
    all_moves.reject do |move|
      new_board = board.dup
      new_board.make_move!(self.position, move)
      new_board.in_check?(self.color)
    end
  end

  def update_pos(new_pos)
    self.position = new_pos
  end


  def attackable?(other_piece)
    return true if color != other_piece.color
    false
  end

  def dup(new_board)
    new_position = position.dup
    new_color = self.color
    self.class.new(new_position, new_board, new_color)
  end

  private
  def add_positions(current_position, direction)
    current_row, current_col = current_position
    direction_row, direction_col = direction
    [current_row + direction_row, current_col + direction_col]
  end

end

class EmptySpace
  def to_s
    "   "
  end

  def attackable?(other_piece)
    false
  end

  def empty?
    true
  end

  def position
    nil
  end

  def color
    nil
  end

  def valid_moves
    []
  end

  def dup(new_board)
    self.class.new
  end

end
