class Grid
  attr_accessor :visited, :edges, :size

  def initialize(size:)
    @size = size
    @visited = {}
    init_grid
  end

  def visit(point)
    raise "Point #{point} is not a valid point" unless point.is_a?(Hash) && point.key?(:row) && point.key?(:col)

    visited[point] = true
  end

  def all_visited?
    visited.select { |_, value| value }.length == size * size
  end

  def is_valid_move?(from:, to:)
    edges[from][to] != nil
  end

  def move_cost(from:, to:)
    raise 'Invalid move' unless is_valid_move?(from: from, to: to)

    edges[from][to]
  end

  def max_col
    size - 1
  end

  def max_row
    size - 1
  end

  # Returns a list of unvisited points
  def remaining_points
    (0...size).flat_map do |row|
      (0...size).map do |col|
        point = { row: row, col: col }
        point unless visited[point]  # Include only unvisited points
      end
    end.compact
  end  

  private

  attr_accessor :size

  def init_grid
    @edges = {}

    moves = {
      -1 => [0],
      0 => [-1, 1],
      1 => [0]
    }

    (0..size - 1).each do |row|
      (0..size - 1).each do |col|
        from = {row: row, col: col}

        unless edges[from]
          edges[from] = {}
          edges[from][from] = 0
          visited[from] = false
        end

        moves.each_key do |x_direction|
          moves[x_direction].each do |y_direction|
            neighbour_x = row + x_direction
            neighbour_y = col + y_direction

            next unless neighbour_x.between?(0, size - 1) && neighbour_y.between?(0, size - 1)

            to = {row: neighbour_x, col: neighbour_y}

            next if edges.key?(from) && edges[from].key?(to)
            next if edges.key?(to) && edges[to].key?(from)

            weight = rand(1..10)

            edges[from] = {} unless edges[from]
            edges[from][to] = weight

            edges[to] = {} unless edges[to]
            edges[to][from] = weight

            puts "Building edge (#{row}, #{col}) -> (#{neighbour_x}, #{neighbour_y}) = #{weight}"
          end
        end
      end
    end
  end
end