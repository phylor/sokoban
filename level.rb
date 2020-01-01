class Level
  WALL = 97
  GROUND = 89

  TILE_SIZE = 64

  MAP = [
    [WALL, WALL, WALL, WALL],
    [WALL, GROUND, GROUND, WALL],
    [WALL, GROUND, GROUND, WALL],
    [WALL, GROUND, GROUND, WALL],
    [WALL, GROUND, GROUND, WALL],
    [WALL, WALL, WALL, WALL]
  ]

  def initialize
    @sprites = Gosu::Image.load_tiles 'assets/kenney_sokobanpack/Tilesheet/sokoban_tilesheet.png', TILE_SIZE, TILE_SIZE
    @player = Player.new(1, 1)
  end

  def draw
    MAP.each_with_index do |array, row|
      array.each_with_index do |tile_type, column|
        @sprites[tile_type].draw column * TILE_SIZE, row * TILE_SIZE, 1
      end
    end

    @player.draw
  end
end
