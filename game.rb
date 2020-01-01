require 'gosu'

require_relative './level'
require_relative './player'
require_relative './start_screen'
require_relative './display'

class Game < Gosu::Window
  def initialize
    super Display::WIDTH, Display::HEIGHT

    @start_screen = StartScreen.new
    @state = :start
  end

  def draw
    draw_background

    case @state
    when :start
      @start_screen.draw
    when :level
      Gosu.translate(50, 50) do
        @level.draw
      end
    when :win
      Gosu.draw_rect(0, 0, Display::WIDTH, Display::HEIGHT, 0xff_1C8749)

      @win_message = Gosu::Image.from_text('You win!', 40, width: Display::WIDTH, align: :center, font: 'assets/Kenney Future.ttf')
      @win_message.draw(0, Display::HEIGHT / 2 - 40, 2)

      @next_level_message = Gosu::Image.from_text(@level.next_level? ? 'Next level [enter]' : 'Quit [enter]', 20, width: Display::WIDTH, align: :center, font: 'assets/Kenney Future.ttf')
      @next_level_message.draw(0, Display::HEIGHT / 2, 2)
    end
  end

  def button_up(id)
    case @state
    when :start
      @start_screen.button_up(id) do |action|
        case action
        when :new_game
          @level = Level.new
          @state = :level
        when :quit
          close
        end
      end
    when :level, :win
      @level.button_up(id)

      @state = :win if @level.solved?

      if @state == :win && (id == Gosu::KbEnter || id == Gosu::KbReturn)
        if @level.next_level?
          @level.next_level
          @state = :level
        else
          @state = :start
        end
      end
    end
  end

  private

  def draw_background
    Gosu.draw_rect(0, 0, Display::WIDTH, Display::HEIGHT, 0xff_596A6C)
  end
end

Game.new.show
