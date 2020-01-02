require 'singleton'

class Sprites
  include Singleton

  TILE_SIZE = 64

  WALL = 97
  GROUND = 89
  BOX = 6
  GOAL = 25
  NOTHING = 0

  PLAYER = 65

  def initialize
    @@sprites = Gosu::Image.load_tiles 'assets/kenney_sokobanpack/Tilesheet/sokoban_tilesheet.png', TILE_SIZE, TILE_SIZE
    @@misc = Gosu::Image.load_tiles 'assets/sheet_white1x.png', 50, 50
  end

  def [](index)
    @@sprites[index]
  end

  def misc
    @@misc
  end
end
