require 'matrix'

class Level
  WALL = 97
  GROUND = 89
  BOX = 6

  TILE_SIZE = 64

  MAP = [
    [WALL, WALL, WALL, WALL],
    [WALL, GROUND, GROUND, WALL],
    [WALL, BOX, BOX, WALL],
    [WALL, GROUND, GROUND, WALL],
    [WALL, GROUND, GROUND, WALL],
    [WALL, WALL, WALL, WALL]
  ]

  def initialize
    @sprites = Gosu::Image.load_tiles 'assets/kenney_sokobanpack/Tilesheet/sokoban_tilesheet.png', TILE_SIZE, TILE_SIZE
    @player = Player.new(2, 1)
  end

  def draw
    # Draw ground everywhere first, to cover eventual holes
    MAP.each_with_index do |array, row|
      array.each_with_index do |tile_type, column|
        @sprites[GROUND].draw column * TILE_SIZE, row * TILE_SIZE, 1
      end
    end

    MAP.each_with_index do |array, row|
      array.each_with_index do |tile_type, column|
        @sprites[tile_type].draw column * TILE_SIZE, row * TILE_SIZE, 1
      end
    end

    @player.draw
  end

  def button_up(id)
    target = case id
    when Gosu::KbRight
      Vector[@player.x + 1, @player.y]
    when Gosu::KbLeft
      Vector[@player.x - 1, @player.y]
    when Gosu::KbUp
      Vector[@player.x, @player.y - 1]
    when Gosu::KbDown
      Vector[@player.x, @player.y + 1]
    else
      Vector[@player.x, @player.y]
    end

    case MAP[target[1]][target[0]]
    when GROUND
      @player.x = target[0]
      @player.y = target[1]
    when BOX
      push_vector = Vector[target[0] - @player.x, target[1] - @player.y]
      box_target = target + push_vector

      case MAP[box_target[1]][box_target[0]]
      when GROUND
        @player.x = target[0]
        @player.y = target[1]

        MAP[box_target[1]][box_target[0]] = BOX
        MAP[target[1]][target[0]] = GROUND
      end
    end
  end
end
