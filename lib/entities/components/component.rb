class Component

  def initialize(game_object = nil)
    self.object = game_object
  end

  def update
    # To be overriden by children
  end

  def draw(viewport)
    # To be overriden by children
  end

  protected

  def object = (obj)
    if obj
      @object = obj
      obj.components << self
    end
  end

  def x
    @object.x
  end

  def y
    @object.y
  end

  def object
    @object
  end

end
