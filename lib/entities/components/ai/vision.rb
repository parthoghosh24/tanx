class AiVison
  CACHE_TIMEOUT = 500
  attr_reader :in_sight

  def initialize(viewer, object_pool, distance)
    @viewer = viewer
    @object_pool = object_pool
    @distance = distance
  end

  def update
    @in_sight = @object_pool.nearby(@viewer,@distance)
  end

  def closest_tank
    now = Gosu.milliseconds
    @closest_tank = nil
    if now - (@cache_updated_at ||= 0) > CACHE_TIMEOUT
      @closest_tank = nil
      @cache_updated_at = now
    end
    @closest_tank ||= find_closest_tank
  end

  private

  def find_closest_tank
    @in_sight.select do |obj|
      obj.class == Tank && !obj.health.dead?
    end.sort do |first ,second|
      x,y =  @viewer.x, @viewer.y
      dist1 = Utils.distance_between(x,y,first.x,first.y)
      dist2 = Utils.distance_between(x,y,second.x,second.y)
      dist1 <=> dist2
    end.first
  end
end
