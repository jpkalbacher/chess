require_relative 'all_pieces'
require_relative 'errors'
require 'byebug'

class Board

  attr_accessor :kings

  def initialize(setup = true)
    @grid = Array.new(8) { Array.new(8) { EmptySpace.new } }
    @kings = []
    setup_board if setup
  end

  def setup_board
    setup_black
    setup_white
  end

  def setup_black
    grid[6].map!.each_with_index do |_, col_index|
      Pawn.new([6, col_index], self, :black)
    end

    grid[7].map!.with_index do |_, col_index|
      if col_index == 0 || col_index == 7
        Rook.new([7, col_index], self, :black)
      elsif col_index == 1 || col_index == 6
        Knight.new([7, col_index], self, :black)
      elsif col_index == 2 || col_index == 5
        Bishop.new([7, col_index], self, :black)
      elsif col_index == 3
        King.new([7, col_index], self, :black)
      elsif col_index == 4
        Queen.new([7, col_index], self, :black)
      end
    end
  end

  def setup_white
    grid[1].map!.each_with_index do |_, col_index|
      Pawn.new([1, col_index], self, :white)
    end

    grid[0].map!.with_index do |_, col_index|
      if col_index == 0 || col_index == 7
        Rook.new([0, col_index], self, :white)
      elsif col_index == 1 || col_index == 6
        Knight.new([0, col_index], self, :white)
      elsif col_index == 2 || col_index == 5
        Bishop.new([0, col_index], self, :white)
      elsif col_index == 3
        King.new([0, col_index], self, :white)
      elsif col_index == 4
        Queen.new([0, col_index], self, :white)
      end
    end
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos,value)
    row, col = pos
    grid[row][col] = value
  end

  def in_bounds?(pos)
    row,col = pos
    (0..7).include?(row) && (0..7).include?(col)
  end

  def rows
    grid
  end

  def make_move(start_pos, end_pos)
    start_piece = self[start_pos]
    self[start_pos], self[end_pos] = EmptySpace.new, start_piece
    start_piece.update_pos(end_pos)
  end

  def make_move!(start_pos, end_pos)
    start_piece = self[start_pos]
    self[start_pos], self[end_pos] = EmptySpace.new, start_piece
    start_piece.update_pos(end_pos)
  end

  def in_check?(color)
    king = kings.select { |king| king.color == color}.first
    king_position = king.position
    pieces = opponent_pieces(king.color)
    all_moves = []
    pieces.each do |piece|
      all_moves.concat(piece.moves)
    end
    return true if all_moves.include?(king_position)
    false
  end

  def checkmate?(color)
    in_check?(color) && own_pieces(color).none? { |piece| piece.valid_moves.count > 0 }
  end

  # private
  attr_accessor :grid

  def dup
    new_board = Board.new(false)

    grid.flatten.each do |space|
      new_position = space.position

      new_space = space.dup(new_board)
      new_board[new_position] = new_space unless new_position.nil?
    end
    new_board
  end

  def opponent_pieces(color)
    grid.flatten.select do |space|
      space.color && space.color != color && !kings.include?(space)
    end
  end

  def own_pieces(color)
    grid.flatten.select do |space|
      space.color && space.color == color && !kings.include?(space)
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  b = Board.new(false)
  k = King.new([0,0], b, :black)
  q = Queen.new([1,1], b, :white)
  b[[0,0]] = k
  b[[1,1]] = q
  p b.checkmate?(:black)
end
