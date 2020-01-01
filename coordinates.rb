class Coordinates
  TILE_SIZE = 64

  def self.game_to_display(x, y)
    [x * 64, y * 64]
  end
end
