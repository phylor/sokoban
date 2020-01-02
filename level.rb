require 'matrix'
require 'yaml'

require_relative './sprites'
require_relative './header'
require_relative './level_loader'
require_relative './sokoban'

class Level
  def initialize
    @levels = Dir['levels/*'].sort
    @current_level_index = -1

    @player = Player.new
    @header = Header.new(@player, self)

    next_level
  end

  def load_level(filename)
    level = LevelLoader.new(filename)

    @player.position = level.player
    @sokoban = Sokoban.new(level.map, level.goals, @player)
  end

  def next_level
    return unless next_level?

    @current_level_index += 1

    load_level(@levels[@current_level_index])

    @last_move = nil
  end

  def next_level?
    @current_level_index < @levels.length - 1
  end

  def level_number
    @current_level_index
  end

  def draw
    Gosu.translate((Display::WIDTH - level_pixel_size[0]) / 2, (Display::HEIGHT - level_pixel_size[1] - Header::HEIGHT) / 2 + Header::HEIGHT) do
      # Draw ground everywhere first, to cover eventual holes
      @sokoban.map.each_with_index do |array, row|
        array.each_with_index do |tile_type, column|
          next if tile_type == Sprites::NOTHING

          Sprites.instance[Sprites::GROUND].draw column * Sprites::TILE_SIZE, row * Sprites::TILE_SIZE, 1
        end
      end

      @sokoban.map.each_with_index do |array, row|
        array.each_with_index do |tile_type, column|
          Sprites.instance[tile_type].draw column * Sprites::TILE_SIZE, row * Sprites::TILE_SIZE, 1
        end
      end

      @sokoban.goals.each do |position, solved|
        Sprites.instance[Sprites::GOAL].draw position[0] * Sprites::TILE_SIZE, position[1] * Sprites::TILE_SIZE, 2

        if solved
          Sprites.instance[74].draw position[0] * Sprites::TILE_SIZE, position[1] * Sprites::TILE_SIZE, 3
        end
      end

      @player.draw
    end

    @header.draw
  end

  def level_pixel_size
    rows = @sokoban.map.length
    columns = @sokoban.map.map { |row| row.length }.max

    Vector[columns * Sprites::TILE_SIZE, rows * Sprites::TILE_SIZE]
  end

  def button_up(key)
    case key
    when Gosu::KB_U
      @sokoban.undo
    when Gosu::KB_R
      load_level(@levels[@current_level_index])

      @last_move = nil
    when Gosu::KbLeft, Gosu::KbRight, Gosu::KbUp, Gosu::KbDown
      target = @player.position + move_vector(key)

      @sokoban.move_player(from: @player.position, to: target) do |events|
        events.each do |event|
          case event
          when :box_moved
            Sounds[:shift].play
            @player.moves += 1
          when :box_solved
            Sounds[:final_place].play
            @player.moves += 1
          end
        end
      end
    end
  end

  def move_vector(key)
    case key
    when Gosu::KbRight
      Vector[1, 0]
    when Gosu::KbLeft
      Vector[-1, 0]
    when Gosu::KbUp
      Vector[0, -1]
    when Gosu::KbDown
      Vector[0, 1]
    else
      Vector[0, 0]
    end
  end

  def solved?
    @sokoban.solved?
  end
end
