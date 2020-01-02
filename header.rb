class Header
  HEIGHT = 50

  def initialize(player, level)
    @player = player
    @level = level

    @phone = Gosu::Image.new('assets/phone.png')
    @font = Gosu::Font.new(20, name: 'assets/Kenney Future.ttf')
  end

  def draw
    @player.undos.times do |index|
      @phone.draw(10 + index * 25, 10, 1, 0.4, 0.4)
    end

    @font.draw_text('[u] undo', 10 + @player.undos * 25 + 20, 20, 1)

    @font.draw_text_rel("Level #{@level.level_number + 1}", Display::WIDTH / 2, HEIGHT / 2, 1, 0.5, 0.5)

    @font.draw_text_rel("Moves: #{@player.moves}", Display::WIDTH - 10, HEIGHT / 2, 1, 1.0, 0.5)
  end
end
