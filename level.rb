require 'matrix'
require 'yaml'

require_relative './sprites'
require_relative './header'
require_relative './level_loader'

class Level
  HEADER_HEIGHT = 50

  def initialize
    @levels = Dir['levels/*'].sort
    @current_level_index = -1

    @player = Player.new
    @header = Header.new(@player)

    next_level
  end

  def load_level(filename)
    level = LevelLoader.new(filename)

    @map = level.map
    @goals = level.goals
    @player.position = level.player
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

  def draw
    Gosu.translate((Display::WIDTH - level_pixel_size[0]) / 2, (Display::HEIGHT - level_pixel_size[1] - HEADER_HEIGHT) / 2 + HEADER_HEIGHT) do
      # Draw ground everywhere first, to cover eventual holes
      @map.each_with_index do |array, row|
        array.each_with_index do |tile_type, column|
          next if tile_type == Sprites::NOTHING

          Sprites.instance[Sprites::GROUND].draw column * Sprites::TILE_SIZE, row * Sprites::TILE_SIZE, 1
        end
      end

      @map.each_with_index do |array, row|
        array.each_with_index do |tile_type, column|
          Sprites.instance[tile_type].draw column * Sprites::TILE_SIZE, row * Sprites::TILE_SIZE, 1
        end
      end

      @goals.each do |position|
        Sprites.instance[Sprites::GOAL].draw position[0] * Sprites::TILE_SIZE, position[1] * Sprites::TILE_SIZE, 2

        if box_coordinates.include?(position)
          Sprites.instance[74].draw position[0] * Sprites::TILE_SIZE, position[1] * Sprites::TILE_SIZE, 3
        end
      end

      @player.draw
    end

    @header.draw
  end

  def level_pixel_size
    rows = @map.length
    columns = @map.map { |row| row.length }.max

    Vector[columns * Sprites::TILE_SIZE, rows * Sprites::TILE_SIZE]
  end

  def button_up(id)
    case id
    when Gosu::KB_U
      if @last_move && @player.undos > 0
        @player.undos -= 1

        @player.position = @last_move[:before][:player]

        box_after = @last_move[:after][:box]
        box_before = @last_move[:before][:box]

        @map[box_after[1]][box_after[0]] = Sprites::GROUND
        @map[box_before[1]][box_before[0]] = Sprites::BOX
      end
      return
    end

    target = @player.position + case id
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

    case @map[target[1]][target[0]]
    when Sprites::GROUND
      @player.position = target
    when Sprites::BOX
      push_vector = target - @player.position
      box_target = target + push_vector

      case @map[box_target[1]][box_target[0]]
      when Sprites::GROUND, Sprites::GOAL
        @last_move = {
          before: { player: @player.position, box: target },
          after: { player: target, box: box_target }
        }

        @player.position = target

        @map[box_target[1]][box_target[0]] = Sprites::BOX
        @map[target[1]][target[0]] = Sprites::GROUND

        if @goals.include?(box_target.to_a)
          Gosu::Sample.new('assets/sound/final_place.ogg').play
        else
          Gosu::Sample.new('assets/sound/shift.ogg').play
        end
      end
    end
  end

  def solved?
    @goals.sort.all? { |goal| box_coordinates.include?(goal) }
  end

  def box_coordinates
    @map.map.with_index do |row, row_index|
      row.map.with_index do |cell, column_index|
        { type: cell, x: column_index, y: row_index }
      end
    end.flatten(1).select { |cell| cell[:type] == Sprites::BOX }.map do |box|
      [box[:x], box[:y]]
    end
  end
end
