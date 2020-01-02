class Sounds
  @@sounds = {
    final_place: Gosu::Sample.new('assets/sound/final_place.ogg'),
    shift: Gosu::Sample.new('assets/sound/shift.ogg'),
    congratulations: Gosu::Sample.new('assets/sound/congratulations.ogg')
  }

  def self.[](key)
    @@sounds[key]
  end
end
