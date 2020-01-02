class Header
  def initialize(player)
    @player = player

    @phone = Gosu::Image.new('assets/phone.png')
    @font = Gosu::Font.new(20, name: 'assets/Kenney Future.ttf')
  end

  def draw
    @player.undos.times do |index|
      @phone.draw(10 + index * 25, 10, 1, 0.4, 0.4)
    end

    @font.draw_text('[u] undo', 10 + @player.undos * 25 + 20, 20, 1)
  end
end
