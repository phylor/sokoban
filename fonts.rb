class Fonts
  @@fonts = {
    normal: Gosu::Font.new(20, name: 'assets/Kenney Future.ttf'),
    title: Gosu::Font.new(80, name: 'assets/Kenney Future.ttf')
  }

  def self.[](key)
    @@fonts[key]
  end
end
