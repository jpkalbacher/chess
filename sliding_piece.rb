require_relative 'pieces'

class SlidingPiece < Piece
  def moves
    possible_moves = []
    slide_dir.each do |direction|
      next_space = add_positions(position, direction)

      while true
        break unless board.in_bounds?(next_space)

        if board[next_space].empty?
          possible_moves << next_space
        elsif board[next_space].attackable?(self)
          possible_moves << next_space
          break
        else
          break
        end

        next_space = add_positions(next_space, direction)
      end
    end
    possible_moves
  end

end
