class StartScreen
  def initialize
    @menu_entries = %i[new_game quit]
    @selected = 0
  end

  def draw
    Gosu.draw_rect(0, 0, Display::WIDTH, Display::HEIGHT, 0xff_FAF0DC)

    title = Gosu::Image.from_text('Sokoban', 80, width: Display::WIDTH, align: :center, font: 'assets/Kenney Future.ttf')
    title.draw(0, 50, 1, 1, 1, 0xff_000000)

    new_game = Gosu::Image.from_text('New game', 20, width: Display::WIDTH, align: :center, font: 'assets/Kenney Future.ttf')
    new_game.draw(0, 200, 1, 1, 1, 0xff_000000)
    Sprites.instance.misc[180].draw(200, 185, 1, 1, 1, 0xff_2DCB70) if @menu_entries[@selected] == :new_game

    quit = Gosu::Image.from_text('Quit', 20, width: Display::WIDTH, align: :center, font: 'assets/Kenney Future.ttf')
    quit.draw(0, 250, 1, 1, 1, 0xff_000000)
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
