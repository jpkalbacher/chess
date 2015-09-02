require_relative 'display'

class Player
  attr_reader :color

  def initialize(name,color = :white, board)
    @name = name
    @color = color
    @display = Display.new(board)
  end

  def move
    result = nil
    until result
      display.render
      puts "It's #{color}'s turn to move."
      result = display.get_input
    end
    result
  end

  private
  attr_reader :display
end
