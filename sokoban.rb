class Sokoban
  def initialize(map, goals, player)
    @map = map
    @goals = goals
    @player = player
  end

  def map
    @map
  end

  def goals
    @goals.map do |position|
      [position, boxes.include?(position)]
    end
  end

  def move_player(from:, to:)
    case @map[to[1]][to[0]]
    when Sprites::GROUND
      @player.position = to

      yield [:player_moved, to: to]
    when Sprites::BOX
      push_vector = to - from
      box_target = to + push_vector

      case @map[box_target[1]][box_target[0]]
      when Sprites::GROUND, Sprites::GOAL
        @last_move = {
          before: { player: @player.position, box: to },
          after: { player: to, box: box_target }
        }

        @player.position = to

        @map[to[1]][to[0]] = Sprites::GROUND
        @map[box_target[1]][box_target[0]] = Sprites::BOX

        yield [
          [:player_moved, from: from, to: to],
          [:boxed_moved, from: to, to: box_target]
        ]
      end
    end
  end

  def undo
    if @last_move && @player.undos > 0
      @player.undos -= 1

      @player.position = @last_move[:before][:player]

      box_after = @last_move[:after][:box]
      box_before = @last_move[:before][:box]

      @map[box_after[1]][box_after[0]] = Sprites::GROUND
      @map[box_before[1]][box_before[0]] = Sprites::BOX
      
      @last_move = nil
    end
  end

  def solved?
    @goals.sort.all? { |goal| boxes.include?(goal) }
  end

  private

  def boxes
    @map.map.with_index do |row, row_index|
      row.map.with_index do |cell, column_index|
        { type: cell, x: column_index, y: row_index }
      end
    end.flatten(1).select { |cell| cell[:type] == Sprites::BOX }.map do |box|
      [box[:x], box[:y]]
    end
  end
end
