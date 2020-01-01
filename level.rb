require 'matrix'
require 'yaml'

class Level
  WALL = 97
  GROUND = 89
  BOX = 6
  GOAL = 25

  TILE_SIZE = 64

  def initialize
    @sprites = Gosu::Image.load_tiles 'assets/kenney_sokobanpack/Tilesheet/sokoban_tilesheet.png', TILE_SIZE, TILE_SIZE

    @levels = Dir['levels/*'].sort
    @current_level_index = -1

    next_level
  end

  def load_level(filename)
    level = YAML::load_file(filename)

    @map = level['map']['initial'].map do |row|
      row.map do |cell|
        eval(cell.to_s.upcase)
      end
    end

    @goals = level['goals']

    level
  end

  def next_level
    return unless next_level?

    @current_level_index += 1
    level = load_level(@levels[@current_level_index])

    @player = Player.new(level['player']['initial']['x'], level['player']['initial']['y'])
  end

  def next_level?
    @current_level_index < @levels.length - 1
  end

  def draw
    # Draw ground everywhere first, to cover eventual holes
    @map.each_with_index do |array, row|
      array.each_with_index do |tile_type, column|
        @sprites[GROUND].draw column * TILE_SIZE, row * TILE_SIZE, 1
      end
    end

    @map.each_with_index do |array, row|
      array.each_with_index do |tile_type, column|
        @sprites[tile_type].draw column * TILE_SIZE, row * TILE_SIZE, 1
      end
    end

    @goals.each do |position|
      @sprites[GOAL].draw position[0] * TILE_SIZE, position[1] * TILE_SIZE, 2

      if box_coordinates.include?(position)
        @sprites[74].draw position[0] * TILE_SIZE, position[1] * TILE_SIZE, 3
      end
    end

    @player.draw
  end

  def button_up(id)
    target = case id
    when Gosu::KbRight
      Vector[@player.x + 1, @player.y]
    when Gosu::KbLeft
      Vector[@player.x - 1, @player.y]
    when Gosu::KbUp
      Vector[@player.x, @player.y - 1]
    when Gosu::KbDown
      Vector[@player.x, @player.y + 1]
    else
      Vector[@player.x, @player.y]
    end

    case @map[target[1]][target[0]]
    when GROUND
      @player.x = target[0]
      @player.y = target[1]
    when BOX
      push_vector = Vector[target[0] - @player.x, target[1] - @player.y]
      box_target = target + push_vector

      case @map[box_target[1]][box_target[0]]
      when GROUND, GOAL
        @player.x = target[0]
        @player.y = target[1]

        @map[box_target[1]][box_target[0]] = BOX
        @map[target[1]][target[0]] = GROUND
      end
    end
  end

  def solved?
    box_coordinates.sort == @goals.sort
  end

  def box_coordinates
    @map.map.with_index do |row, row_index|
      row.map.with_index do |cell, column_index|
        { type: cell, x: column_index, y: row_index }
      end
    end.flatten(1).select { |cell| cell[:type] == BOX }.map do |box|
      [box[:x], box[:y]]
    end
  end
end
