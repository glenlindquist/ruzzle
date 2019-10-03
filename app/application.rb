require 'opal'
require 'browser'
require 'browser/canvas'

class Grid
  attr_reader :height, :width, :canvas, :max_x, :max_y

  CELL_HEIGHT = 15
  CELL_WIDTH = 15

  def initialize(options)
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

end

main = Grid.new(height: 500, width: 500)
main.draw_grid
main.draw_cell(2, 2, "red")
main.draw_cell(3, 3, "blue")

# $document.ready do
#   puts "Ready"
#   main.canvas.append_to($document.body)
#   puts "Finished"
# end