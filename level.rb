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
    @player = Player.new(2, 1)
  end

  def draw
    MAP.each_with_index do |array, row|
      array.each_with_index do |tile_type, column|
        @sprites[tile_type].draw column * TILE_SIZE, row * TILE_SIZE, 1
      end
    end

    @player.draw
  end

  def button_up(id)
    case id
    when Gosu::KbRight
      target = @player.x + 1

      @player.x = target if MAP[@player.y][target] == GROUND
    when Gosu::KbLeft
      target = @player.x - 1

      @player.x = target if MAP[@player.y][target] == GROUND
    when Gosu::KbUp
      target = @player.y - 1

      @player.y = target if MAP[target][@player.x] == GROUND
    when Gosu::KbDown
      target = @player.y + 1

      @player.y = target if MAP[target][@player.x] == GROUND
    end
  end
end
