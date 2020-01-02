require_relative './fonts'

class StartScreen
  def initialize
    @menu_entries = %i[new_game quit]
    @selected = 0
  end

  def draw
    Gosu.draw_rect(0, 0, Display::WIDTH, Display::HEIGHT, 0xff_FAF0DC)

    Fonts[:title].draw_text_rel('Sokoban', Display::WIDTH / 2, 50, 1, 0.5, 0, 1, 1, 0xff_000000)

    Fonts[:normal].draw_text_rel('New game', Display::WIDTH / 2, 200, 1, 0.5, 0, 1, 1, 0xff_000000)
    Sprites.instance.misc[180].draw(200, 185, 1, 1, 1, 0xff_2DCB70) if @menu_entries[@selected] == :new_game

    Fonts[:normal].draw_text_rel('Quit', Display::WIDTH / 2, 250, 1, 0.5, 0, 1, 1, 0xff_000000)
    Sprites.instance.misc[180].draw(200, 235, 1, 1, 1, 0xff_2DCB70) if @menu_entries[@selected] == :quit

    Sprites.instance[65].draw(50, Display::HEIGHT - 2 * Sprites::TILE_SIZE, 1)
  end

  def button_up(id)
    case id
    when Gosu::KbDown
      @selected = (@selected + 1) % @menu_entries.length
    when Gosu::KbUp
      @selected = (@selected - 1) % @menu_entries.length
    when Gosu::KbReturn, Gosu::KbEnter
      yield @menu_entries[@selected]
    end
  end
end
