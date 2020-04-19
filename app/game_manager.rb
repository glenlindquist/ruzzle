class GameManager
  attr_accessor :grid
  attr_reader :player, :entities, :history, :grid_width, :grid_height, :enable_grid

  def initialize(options = {})
    if options[:map]
      parse_map(options[:map])
    end
    @enable_grid = options[:enable_grid] || true
    @grid_height ||= options[:grid_height]
    @grid_width ||= options[:grid_widght]

    @grid = options[:grid]

    @player ||= add_entity(Player.new)

    @history = []
  end

  def add_entity(entity)
    @entities ||= []
    return if @entities.include? entity
    @entities << entity
    entity.game = self
    entity
  end

  def remove_entity(entity)
    @entities -= [entity]
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
    when 'z'
      undo
    when 'r'
      reset
    when 'q'
      puts @player.coordinates
      puts @player.type
    end
    update
  end

  def entities_at(x, y)
    @entities.select{|entity| entity.x == x && entity.y == y}
  end

  def teleporters(teleporter_channel = nil)
    if teleporter_channel
      @entities.select{|e| e.type == "teleporter" && e.teleporter_channel == teleporter_channel}
    else
      @entities.select{|e| e.type == "teleporter" }
    end
  end

  private

  def update
    handle_after_move
    draw_game(@enable_grid)
    save_state
  end

  def handle_after_move
    #@TODO. handling teleporter?
  end

  def draw_game(enable_grid_flag)
    @grid.clear
    @entities.sort_by{|e| e.render_layer}.each do |entity|
      @grid.draw_cell(entity.x, entity.y, entity.color)
    end
    @grid.draw_grid if enable_grid_flag
  end

  def save_state
    history << state
  end

  def undo
    return if @history.length <= 1
    load_state(@history[-2])
    @history = @history.first(@history.size - 2)
  end

  def reset
    @history = @history.first(1)
    load_state(@history.last)
  end

  def load_state(state)
    state.each do |entity_info|
      add_entity(entity_info[:entity])
      entity_info[:entity].x = entity_info[:x]
      entity_info[:entity].y = entity_info[:y]
    end
  end

  def state
    @entities.map {|e| {entity: e, x: e.x, y: e.y}}
  end

  # def blocked_at?(x, y)
  #   @entities.select?{|e| e.x == x && e.y == y}.each do |e|
  #     e.accepts?
  #   end
  # end

  def parse_map(map, options = {})
    player_glyph = options[:player_glyph] || "P"
    wall_glyph = options[:wall_glph] || "W"
    box_glyph = options[:wall_glph] || "B"
    hole_glyph = options[:wall_glph] || "H"
    goal_glyph = options[:wall_glph] || "G"
    teleporter_glyph = options[:wall_glph] || /\d/

    rows = map.split("\n").reject{|row| row.empty?}
    if rows.map(&:length).uniq.length != 1
      puts "not rectangular map"
      return false
    end

    @grid_height = rows.length
    @grid_width = rows[0].length

    puts "width: #{@grid_width}"
    puts "height: #{@grid_height}"


    rows.each_with_index do |row, y|
      row.chars.each_with_index do |tile_char, x|
        case tile_char
        when player_glyph
          @player = add_entity(
            Player.new(x: x, y: y, type: "player", color: "green", pushes: ["box"])
          )
        when wall_glyph
          add_entity(
            Entity.new(x: x, y: y, type: "wall", color: "darkgray")
          )
        when box_glyph
          add_entity(
            Entity.new(x: x, y: y, type: "box", color: "red", pushes: ["box"])
          )
        when hole_glyph
          add_entity(
            Entity.new(x: x, y: y, type: "hole", color: "black", destroys: ["box"])
          )
        when goal_glyph
          add_entity(
            Entity.new(x: x, y: y, type:"goal", color: "yellow", collision_layer: 0, render_layer: 0, accepts: ["all"])
          )
        when teleporter_glyph
          add_entity(
            Teleporter.new(x: x, y: y, type:"teleporter", color: "orange", render_layer: 0, teleporter_channel: tile_char.to_i, accepts: ["all"])
          )
        when "."
          # ground
        else
          # for now treat same as ground
        end
      end
    end
  end

  def parse_rules

  end
  
end