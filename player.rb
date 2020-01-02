require_relative './coordinates'

class Player
  TILE_SIZE = 64

  attr_accessor :position
  attr_accessor :undos

  def initialize
    @sprites = Gosu::Image.load_tiles 'assets/kenney_sokobanpack/Tilesheet/sokoban_tilesheet.png', TILE_SIZE, TILE_SIZE

    @undos = 3
  end

  def draw
    @sprites[65].draw position[0] * Sprites::TILE_SIZE, position[1] * Sprites::TILE_SIZE, 2
  end
end
