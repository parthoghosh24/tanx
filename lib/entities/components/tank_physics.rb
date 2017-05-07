class TankPhysics < Component
  attr_accessor :speed

  def initialize(game_object, object_pool)
    super(game_object)
    @object_pool = object_pool
    @map = object_pool.map
    game_object.x, game_object.y = @map.find_spawn_point
    @speed = 0.0
  end

  def can_move_to?(x,y)
    old_x, old_y = object.x,object.y
    object.x = x
    object.y = y
    return false unless @map.can_move_to?(x,y)
    @object_pool.nearby(object, 100).each do |obj|
      if collides_with_poly?(obj.box)
        # @collides_with = obj
        old_distance = Utils.distance_between(obj.x, obj.y, old_x, old_y)
        new_distance = Utils.distance_between(obj.x, obj.y, x, y)
        return false if new_distance < old_distance
      # else
        # @collides_with = nil
      end
    end
    true
  ensure
    object.x = old_x
    object.y = old_y
  end



  def moving?
    @speed > 0
  end

  def update
    if object.throttle_down
      accelerate
    else
      decelerate
    end
    if @speed > 0
      new_x,new_y = x,y
      shift = Utils.adjust_speed(@speed)
      case @object.direction.to_i
      when 0
        new_y -= shift
      when 45
        new_x += shift
        new_y -= shift
      when 90
        new_x += shift
      when 135
        new_x += shift
        new_y += shift
      when 180
        new_y += shift
      when 225
        new_x -= shift
        new_y += shift
      when 270
        new_x -= shift
      when 315
        new_x -= shift
        new_y -= shift
      end
      if can_move_to?(new_x, new_y)
        object.x, object.y = new_x, new_y
        @inertia_x  = @inertia_y = shift
        @in_collision = false
      else
        object.sounds.collide if @speed > 1  #&& @collides_with.class == Tank
        @speed = 0.0
        @in_collision = true
      end
    end
  end

  def box_width
    @box_width ||= object.graphics.width
  end

  def box_height
    @box_height ||= object.graphics.height
  end
  # Tank box looks like H. Vertices:
  # 1  2  5  6
  #    3  4
  #
  #   10  9
  # 12 11 8  7
  def box
    width = box_width / 2 -1
    height = box_height / 2 -1
    track_width = 8
    front_depth = 8
    rear_depth =  6
    Utils.rotate(object.direction, x, y,
                 x + width, y + height,
                 x + width - track_width, y + height,
                 x + width - track_width, y + height - front_depth,

                 x - width + track_width, y + height - front_depth,
                 x - width + track_width, y + height,
                 x - width, y + height,

                 x - width, y - height,
                 x - width + track_width, y - height,
                 x - width + track_width, y - height + rear_depth,

                 x + width - track_width, y - height + rear_depth,
                 x + width - track_width, y - height,
                 x + width, y - height,
                 )
  end

  private

  def accelerate
    @speed +=0.08 if @speed < 5
  end

  def decelerate
    @speed -= 0.5 if @speed > 0
    @speed = 0.0 if @speed < 0.01
  end

  def collides_with_poly?(poly)
    if poly
      if poly.size == 2
        px,py = poly
        return Utils.point_in_poly(px,py,*poly)
      end
      poly.each_slice(2) do |x,y|
        return true if Utils.point_in_poly(x,y,*box)
      end
      poly.each_slice(2) do |x,y|
        return true if Utils.point_in_poly(x,y,*poly)
      end
    end
    false
  end

  def collides_with_point?(x,y)
    Utils.point_in_poly(x,y,box)
  end
end
