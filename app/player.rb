require_relative 'entity'
class Player < Entity
  def initialize(options = {})
    super
    @color = options[:color] || "green"
    @pushes = options[:pushes] || []
    @type = "player"
  end
end