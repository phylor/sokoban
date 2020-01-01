require 'gosu'

require_relative './level'
require_relative './player'

class Game < Gosu::Window
  WIDTH = 640
  HEIGHT = 480

  def initialize
    super WIDTH, HEIGHT

    @level = Level.new
  end

  def draw
    draw_background

    Gosu.translate(50, 50) do
      @level.draw
    end
  end

  private

  def draw_background
    Gosu.draw_rect(0, 0, WIDTH, HEIGHT, 0xff_596A6C)
  end
end

Game.new.show
