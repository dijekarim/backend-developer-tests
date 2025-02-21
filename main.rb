require './game.rb'
require './random_player.rb'
require './your_player.rb'
require './helper.rb'

srand(129)

grid_size = 5

your_strategy = -> {
  game = Game.new(grid_size: grid_size)

  you = YourPlayer.new(game: game, name: 'Dimas JK')

  game.add_player(you)

  game.start
}

random_strategy = -> {
  game = Game.new(grid_size: grid_size)

  random_player = RandomPlayer.new(game: game, name: 'Rando 1')
  random_player2 = RandomPlayer.new(game: game, name: 'Rando 2')

  game.add_player(random_player)
  game.add_player(random_player2)

  game.start
}

random_results = random_strategy.call
your_results = your_strategy.call

compare_hashes(your_results, random_results)
