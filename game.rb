require 'gosu'

require_relative './level'
require_relative './player'

class Game < Gosu::Window
  WIDTH = 640
  HEIGHT = 480

  def initialize
    super WIDTH, HEIGHT

    @level = Level.new
    @state = :level
  end

  def draw
    draw_background

    case @state
    when :level
      Gosu.translate(50, 50) do
        @level.draw
      end
    when :win
      Gosu.draw_rect(0, 0, WIDTH, HEIGHT, 0xff_1C8749)

      @win_message = Gosu::Image.from_text('You win!', 40, width: WIDTH, align: :center, font: 'assets/Kenney Future.ttf')
      @win_message.draw(0, HEIGHT / 2 - 40, 2)
    end
  end

  def button_up(id)
    @level.button_up(id)

    @state = :win if @level.solved?
  end

  private

  def draw_background
    Gosu.draw_rect(0, 0, WIDTH, HEIGHT, 0xff_596A6C)
  end
end

Game.new.show
