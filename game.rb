require './grid.rb'

class Game
  attr_accessor :grid, :total_cost

  def initialize(grid_size:)
    @grid = Grid.new(size: grid_size)
    @players = []

    @players_state = {}

    @total_cost = 0
    @timer = 0
  end

  def add_player(player)
    @players.append(player)
    players_state[player] = { position: nil }
  end

  def start
    puts "Game started! Timer is #{timer}"

    loop do
      puts "Epoch #{@timer}"

      players.each do |player|
        current_position = players_state[player][:position]
        new_position = player.next_point(time: timer)

        if current_position.nil?
          players_state[player][:position] = new_position
          grid.visit(new_position)
          next
        end

        if grid.is_valid_move?(from: current_position, to: new_position)
          grid.visit(new_position)
          @total_cost += grid.edges[current_position][new_position]
          players_state[player][:position] = new_position
        else
          puts "Invalid move for #{player.name}. Skipping..."
        end
      end

      @timer += 1

      break if finished?
    end

    puts "Game finished! Final time is #{timer} and total cost is #{@total_cost}"

    {
      all_visited: grid.all_visited?,
      total_time: timer,
      total_cost: @total_cost
    }
  end

  def timer
    @timer
  end

  def player_position(player)
    players_state[player][:position]
  end

  private

  attr_accessor :players, :visited, :players_state

  MAX_TIME = 1_000_000

  def finished?
    return true if timer > MAX_TIME

    grid.all_visited?
  end
end
