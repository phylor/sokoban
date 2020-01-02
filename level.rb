require 'matrix'
require 'yaml'

require_relative './sprites'

class Level
  WALL = 97
  GROUND = 89
  BOX = 6
  GOAL = 25
  NOTHING = 0

  HEADER_HEIGHT = 50

  def initialize
    @levels = Dir['levels/*'].sort
    @current_level_index = -1
    @phone = Gosu::Image.new('assets/phone.png')
    @undos = 3

    @font = Gosu::Font.new(20, name: 'assets/Kenney Future.ttf')

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
          next if tile_type == NOTHING

          Sprites.instance[GROUND].draw column * Sprites::TILE_SIZE, row * Sprites::TILE_SIZE, 1
        end
      end

      @map.each_with_index do |array, row|
        array.each_with_index do |tile_type, column|
          Sprites.instance[tile_type].draw column * Sprites::TILE_SIZE, row * Sprites::TILE_SIZE, 1
        end
      end

      @goals.each do |position|
        Sprites.instance[GOAL].draw position[0] * Sprites::TILE_SIZE, position[1] * Sprites::TILE_SIZE, 2

        if box_coordinates.include?(position)
          Sprites.instance[74].draw position[0] * Sprites::TILE_SIZE, position[1] * Sprites::TILE_SIZE, 3
        end
      end

      @player.draw
    end

    @undos.times do |index|
      @phone.draw(10 + index * 25, 10, 1, 0.4, 0.4)
    end

    @font.draw_text('[u] undo', 10 + @undos * 25 + 20, 20, 1)
  end

  def level_pixel_size
    rows = @map.length
    columns = @map.map { |row| row.length }.max

    Vector[columns * Sprites::TILE_SIZE, rows * Sprites::TILE_SIZE]
  end

  def button_up(id)
    case id
    when Gosu::KB_U
      if @last_move && @undos > 0
        @undos -= 1

        @player.x = @last_move[:before][:player][0]
        @player.y = @last_move[:before][:player][1]

        box_after = @last_move[:after][:box]
        box_before = @last_move[:before][:box]

        @map[box_after[1]][box_after[0]] = GROUND
        @map[box_before[1]][box_before[0]] = BOX
      end
      return
    end

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
        @last_move = {
          before: { player: Vector[@player.x, @player.y], box: target },
          after: { player: target, box: box_target }
        }

        @player.x = target[0]
        @player.y = target[1]

        @map[box_target[1]][box_target[0]] = BOX
        @map[target[1]][target[0]] = GROUND

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
    end.flatten(1).select { |cell| cell[:type] == BOX }.map do |box|
      [box[:x], box[:y]]
    end
  end
end
