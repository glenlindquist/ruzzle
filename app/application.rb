require 'opal'
require 'browser'
require 'browser/canvas'
require 'browser/event'
require 'browser/window'

class Grid
  attr_reader :height, :width, :canvas, :max_x, :max_y

  CELL_HEIGHT = 15
  CELL_WIDTH = 15

  def initialize(options = {})
    @height = options[:height] || 500
    @width = options[:width] || 500
    @canvas = Browser::Canvas.new(@height, @width)
    @max_x = (width / CELL_WIDTH).floor
    @max_y = (height / CELL_HEIGHT).floor
  end

  def draw_grid
    x = 0.5
    until x >= width do
      @canvas.move_to(x, 0)
      @canvas.line_to(x, @height)
      x += CELL_WIDTH
    end

    y = 0.5
    until y >= height do
      @canvas.move_to(0, y)
      @canvas.line_to(height, y)
      y += CELL_HEIGHT
    end

    @canvas.style.stroke = "#eee"
    @canvas.stroke
  end

  def draw_cell(grid_x, grid_y, cell_color = "#000")
    canvas_x = grid_x * CELL_WIDTH
    canvas_y = grid_y * CELL_HEIGHT
    @canvas.begin
    @canvas.rect(canvas_x, canvas_y, CELL_WIDTH, CELL_HEIGHT)
    @canvas.style.fill = cell_color
    @canvas.fill
  end

  def clear_cell(grid_x, grid_y)
    draw_cell(grid_x, grid_y, "#FFF")
  end

  def clear
    @canvas.clear(0, 0, @width, @height)
  end

end

class GameManager
  attr_reader :grid
  def initialize(options = {})
    @grid = options[:grid] || Grid.new
    @player = options[:player] || Player.new
    @entities = [@player]
  end

  def update
    self.draw_game
  end

  def handle_move(key)
    case key
    when 'a'
      @player.move("left")
    when 'd'
      @player.move("right")
    when 'w'
      @player.move("up")
    when 's'
      @player.move("down")
    end

    # if key == "a"
    #   @player.move("left")
    # elsif key == "d"
    #   @player.move("right")
    # elsif key == "w"
    #   @player.move("up")
    # elsif key == "s"
    #   @player.move("down")
    # end

    update
  end

  def draw_game
    @grid.clear
    @entities.each do |entity|
      @grid.draw_cell(entity.x, entity.y, entity.color)
    end
    @grid.draw_grid
  end
end

class Entity
  attr_reader :x, :y, :color
  def initialize(options = {})
    @x = options[:x] || 0
    @y = options[:y] || 0
    @color = options[:color] || "black"
  end

  def coordinates
    "(#{x}, #{y})"
  end

  def move(direction)
    case direction
    when "left"
      @x -= 1
    when "right"
      @x += 1
    when "up"
      @y -= 1
    when "down"
      @y += 1
    end

    # if direction == "left"
    #   @x -= 1
    # elsif direction == "right"
    #   @x += 1
    # elsif direction == "up"
    #   @y -= 1
    # elsif direction == "down"
    #   @y += 1
    # end
  end

end

class Player < Entity

end

game = GameManager.new
game.update

$window.on('keydown') {|e|
  game.handle_move(e.key)
  puts e.key
}

canvas = game.grid.canvas

# $document.ready do
#   puts "Ready"
#   canvas.append_to($document.body)
#   puts "Finished"
# end