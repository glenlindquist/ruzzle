class Entity
  attr_accessor :game, :x, :y
  attr_reader :color, :type, :render_layer, :collision_layer, :pushes, :destroys, :accepts
 
  def initialize(options = {})
    @x = options[:x] || 0
    @y = options[:y] || 0
    @color = options[:color] || "black"
    @type = options[:type] || ""
    @render_layer = options[:render_layer] || 1
    @collision_layer = options[:collision_layer] || 1
    @pushes = options[:pushes] || []
    @destroys = options[:destroys] || []
    @accepts = options[:accepts] || []
  end

  def destroy
    @game.remove_entity(self)
  end

  def coordinates
    "(#{x}, #{y})"
  end

  def move(direction)
    dx = 0
    dy = 0
    case direction
    when "left"
      dx = -1
    when "right"
      dx = 1
    when "up"
      dy = -1
    when "down"
      dy = 1
    end
    proposed_x = @x + dx
    proposed_y = @y + dy

    obstacles = @game.entities_at(proposed_x, proposed_y).select{|obstacle| obstacle.collision_layer == self.collision_layer}
    return false unless handle_obstacles(obstacles, direction)

    if obstacles.any?{|obstacle| obstacle.type == "teleporter"}
      destination = obstacles.select{|o| o.type == "teleporter"}.first.partner
      if destination.blocked_for?(self)
        # do not teleport
      else
        @x = destination.x
        @y = destination.y
        return true
      end
    end

    # otherwise move!
    @x += dx
    @y += dy
    true

  end

  def handle_obstacles(obstacles, direction)
    obstacles.each do |obstacle|
      # Try destroy first
      if self.destroys?(obstacle)
        obstacle.destroy
        next
      end
      if self.destroyed_by?(obstacle)
        self.destroy
        next
      end

      # See if accepts
      if accepted_by?(obstacle)
        next
      end

      # Else push
      return false unless pushes? obstacle
      return false unless obstacle.move(direction)

    end
    true
  end

  def add_pushable_type(type)
    return if @pushes.include? type
    @pushes << type
  end

  def pushes?(entity)
    @pushes.include?(entity.type) || @pushes.include?("all")
  end

  def pushed_by?(entity)
    enity.pushes? self
  end

  def destroys?(entity)
    @destroys.include?(entity.type) || @destroys.include?("all")
  end

  def destroyed_by?(entity)
    entity.destroys? self
  end

  def accepts?(entity)
    @accepts.include?(entity.type) || @accepts.include?("all")
  end

  def accepted_by?(entity)
    entity.accepts? self
  end

end