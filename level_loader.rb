class LevelLoader
  def initialize(filename)
    @level = YAML::load_file(filename)
  end

  def map
    @level['map']['initial'].map do |row|
      row.map do |cell|
        eval("Sprites::#{cell.to_s.upcase}")
      end
    end
  end

  def goals
    @level['goals']
  end

  def player
    Vector[@level['player']['initial']['x'], @level['player']['initial']['y']]
  end
end
