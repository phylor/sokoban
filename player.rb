require_relative './coordinates'

class Player
  attr_accessor :position
  attr_accessor :undos
  attr_accessor :moves

  def initialize
    @undos = 3
    @moves = 0
  end

  def draw
    Sprites.instance[Sprites::PLAYER].draw position[0] * Sprites::TILE_SIZE, position[1] * Sprites::TILE_SIZE, 2
  end
end
