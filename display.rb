require 'colorize'
require_relative 'cursorable'
require_relative 'board'


class Display
  include Cursorable
  attr_reader :board
  attr_accessor :selected_piece

  def initialize(board)
    @board = board
    @cursor_pos = [0,5]
    @selected_piece = nil
  end

  def build_grid
    @board.rows.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def build_row(row, i)
    row.map.with_index do |piece, j|
      color_options = colors_for(i, j)
      piece.to_s.colorize(color_options)
    end
  end

  def colors_for(i, j)
    if [i, j] == @cursor_pos
      bg = :light_red
    elsif get_valid_moves.include?([i,j])
      bg = :green
    elsif (i + j).odd?
      bg = :light_blue
    else
      bg = :yellow
    end
    { background: bg }
  end

  def get_valid_moves
    board[@cursor_pos].valid_moves
  end

  def render
    system("clear")
    puts "Use the arrows to make a move!"
    build_grid.each { |row| puts row.join }
    nil
  end
end
