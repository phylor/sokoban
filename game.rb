require 'gosu'

class Game < Gosu::Window
  def initialize
    super 640, 480
  end
end

Game.new.show
