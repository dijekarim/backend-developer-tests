require './base_player.rb'
require 'set'

class YourPlayer < BasePlayer
  def next_point(time:)
    return { row: 0, col: 0 } if grid.remaining_points.empty?

    current_position = game.player_position(self) || { row: 0, col: 0 }

    # Find the nearest unvisited point with the lowest movement cost
    next_move = find_lowest_cost_move(current_position)

    next_move
  end

  def grid
    game.grid
  end

  private

  def possible_movements (row, col)
    # Define the possible moves (up, down, left, right)
    [
      { row: row - 1, col: col }, # Up
      { row: row + 1, col: col }, # Down
      { row: row, col: col - 1 }, # Left
      { row: row, col: col + 1 }  # Right
    ]
  end

  # Function to find the next best move with the smallest cost (only up, down, left, right)
  def find_lowest_cost_move(current_position)
    row, col = current_position[:row], current_position[:col]

    possible_moves = possible_movements(row, col)

    # Filter moves that are within bounds and unvisited
    valid_moves = possible_moves.select do |move|
      move[:row].between?(0, grid.max_row) &&
        move[:col].between?(0, grid.max_col) &&
        !grid.visited[move] &&
        grid.edges[current_position][move] # Ensure it's a valid move
    end

    # If there are valid unvisited moves, pick the lowest-cost one
    unless valid_moves.empty?
      return valid_moves.min_by { |move| grid.edges[current_position][move] }
    end

    # If all neighbors are visited, use Breadth First Search to find the shortest path to an unvisited point
    path_to_unvisited = find_path_to_unvisited(current_position)

    # If a path exists, return the first step towards the unvisited point
    path_to_unvisited ? path_to_unvisited.first : current_position
  end

  def find_path_to_unvisited(start_position)
    queue = [[start_position]] # Breadth First Search queue with paths
    visited = { start_position => true } # Track visited nodes in Breadth First Search
  
    while !queue.empty?
      path = queue.shift
      current = path.last
  
      # If we find an unvisited point, return the path (excluding start)
      return path[1..] if !grid.visited[current]
  
      # Explore only valid up/down/left/right neighbors
      possible_moves = possible_movements(current[:row], current[:col])
      neighbors = possible_moves.select do |neighbor|
        neighbor[:row].between?(0, grid.max_row) &&
          neighbor[:col].between?(0, grid.max_col) &&
          !visited[neighbor] &&
          grid.edges[current][neighbor] # Ensure valid edge exists
      end
  
      # Add new paths to the queue
      neighbors.each do |neighbor|
        queue << (path + [neighbor])
        visited[neighbor] = true
      end
    end
  
    nil # return nil if no path found
  end  
end
