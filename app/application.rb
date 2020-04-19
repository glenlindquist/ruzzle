require 'opal'
require 'browser'
require 'browser/canvas'
require 'browser/event'
require 'browser/window'
require_relative "game_manager"
require_relative "grid"
require_relative "entity"
require_relative "player"
require_relative "teleporter"

map = """
WWWWWWWWWWWWWWWWWWWWWWWWWWWWW
W...........................W
W..B........................W
W.............1......G...1..W
W.P.........................W
W.....W.....................W
W.....B.....................W
W..B........................W
W...........................W
W....................H......W
W.............2.............W
W...................2.......W
W...........................W
WWWWWWWWWWWWWWWWWWWWWWWWWWWWW
"""

rules = """
player is green
player pushes box
"""

game = GameManager.new(map: map, rules: rules, draw_grid: true)
game.grid = Grid.new(grid_width: game.grid_width, grid_height: game.grid_height)

game.update

$window.on('keydown') {|e|
  game.handle_move(e.key)
}

canvas = game.grid.canvas

# $document.ready do
#   puts "Ready"
#   canvas.append_to($document.body)
#   puts "Finished"
# end