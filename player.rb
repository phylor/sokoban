require_relative './coordinates'

class Player
  TILE_SIZE = 64

  attr_accessor :x, :y
  attr_accessor :undos

  def initialize(x, y)
    @sprites = Gosu::Image.load_tiles 'assets/kenney_sokobanpack/Tilesheet/sokoban_tilesheet.png', TILE_SIZE, TILE_SIZE

    @x, @y = x, y
    @undos = 3
  end

  def draw
    @sprites[65].draw Coordinates.game_to_display(@x, @y)[0], Coordinates.game_to_display(@x, @y)[1], 2
  end
end
