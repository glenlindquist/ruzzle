class Grid
  attr_reader :height, :width, :canvas, :grid_width, :grid_height

  CELL_HEIGHT = 16
  CELL_WIDTH = 16

  def initialize(options = {})
    @grid_width = options[:grid_width] || 30
    @grid_height = options[:grid_height] || 30
    @height = (@grid_height) * CELL_HEIGHT
    @width = (@grid_width) * CELL_WIDTH
    @canvas = Browser::Canvas.new(@width, @height)

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
      @canvas.line_to(@width, y)
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