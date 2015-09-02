require_relative 'pieces'

class SteppingPiece < Piece
  def moves
    possible_moves = []
    step_dir.each do |direction|
      next_space = add_positions(self.position, direction)
      next unless board.in_bounds?(next_space)
      possible_moves << next_space
    end

    possible_moves.select {|position| board[position].attackable?(self) || board[position].empty? }
  end



end
