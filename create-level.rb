#!/usr/bin/env ruby

require 'yaml'
require 'matrix'

input = STDIN.read

rows = input.lines.length
columns = input.lines.map { |row| row.length }.max

player = []
goals = []

map = input.lines.map.with_index do |line, row|
  mapped = line.chars.map.with_index do |char, column|
    case char
    when '#' then :wall
    when '$' then :box
    when '@'
      player = Vector[column, row]
      :ground
    when '+'
      player = Vector[column, row]
      goals << [column, row]
      :ground
    when '.'
      goals << [column, row]
      :ground
    when '*'
      goals << [column, row]
      :box
    else
      if line[0..column].count('#').even?
        :nothing
      else
        :ground
      end
    end
  end

  mapped.fill(:nothing, mapped.length..columns-1)
end

data = {
  'player' => { 'initial' => {
    'x' => player[0], 'y' => player[1] }
  },
  'map' => { 'initial' => map },
  'goals' => goals
}

puts YAML::dump(data)
