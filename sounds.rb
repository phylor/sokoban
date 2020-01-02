require_relative './null_sound'

class Sounds
  @@sounds = {
    final_place: Gosu::Sample.new('assets/sound/final_place.ogg'),
    shift: Gosu::Sample.new('assets/sound/shift.ogg'),
    congratulations: Gosu::Sample.new('assets/sound/congratulations.ogg')
  }

  @@enabled = true

  def self.[](key)
    if @@enabled
      @@sounds[key]
    else
      NullSound.new
    end
  end

  def self.toggle
    @@enabled = !@@enabled
  end
end
