require './base_player.rb'
require 'set'

class YourPlayer < BasePlayer
  def next_point(time:)
    return { row: 0, col: 0 } if grid.remaining_points.empty?

    current_position = game.player_position(self) || { row: 0, col: 0 }

    next_move = find_lowest_cost_move(current_position)

    next_move
  end

  def grid
    game.grid
  end

  private  
  def find_lowest_cost_move(current_position)
    row, col = current_position[:row], current_position[:col]

    possible_moves = [
      { row: row - 1, col: col }, 
      { row: row + 1, col: col }, 
      { row: row, col: col - 1 }, 
      { row: row, col: col + 1 }  
    ]

    valid_moves = possible_moves.select do |move|
      move[:row].between?(0, grid.max_row) &&
        move[:col].between?(0, grid.max_col) &&
        !grid.visited[move] &&
        grid.edges[current_position][move] 
    end

    unless valid_moves.empty?
      return valid_moves.min_by { |move| grid.edges[current_position][move] }
    end

    path_to_unvisited = find_path_to_unvisited(current_position)

    path_to_unvisited ? path_to_unvisited.first : current_position
  end

  def find_path_to_unvisited(start_position)
    queue = [[start_position]] 
    visited = { start_position => true } 
  
    while !queue.empty?
      path = queue.shift
      current = path.last

      return path[1..] if !grid.visited[current]

      neighbors = [
        { row: current[:row] - 1, col: current[:col] }, 
        { row: current[:row] + 1, col: current[:col] }, 
        { row: current[:row], col: current[:col] - 1 }, 
        { row: current[:row], col: current[:col] + 1 }  
      ].select do |neighbor|
        neighbor[:row].between?(0, grid.max_row) &&
          neighbor[:col].between?(0, grid.max_col) &&
          !visited[neighbor] &&
          grid.edges[current][neighbor] 
      end

      neighbors.each do |neighbor|
        queue << (path + [neighbor])
        visited[neighbor] = true
      end
    end
  
    nil 
  end  
end
