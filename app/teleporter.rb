class Teleporter < Entity
  attr_reader :teleporter_channel
  def initialize(options = {})
    @type = "teleporter"
    @teleporter_channel = options[:teleporter_channel] || 0
    super
  end

  def teleport(entity)
    elligible_teleporters = @game.teleporters(@teleporter_channel).reject{|t| t == self}
    # elligible_teleporters.each do |teleporter|
    # # check if teleporter is open before sending
    #   teleporter.
    # end
    teleporter = elligible_teleporters.first
    entity.x = teleporter.x
    entity.y = teleporter.y
    true
  end

  def partner
    @game.teleporters(@teleporter_channel).reject{|t| t == self}.first
  end

  def blocked_for?(entity)
    other_occupants = @game.entities_at(@x, @y)
    other_occupants.any? {|e| !e.accepts? entity}
  end

end