class Tank < GameObject

  attr_accessor :x, :y, :throttle_down, :direction, :gun_angle, :sounds, :physics
  SHOOT_DELAY = 500

  def initialize(object_pool, input)
    super(object_pool)
    @input = input
    @input.control(self)
    @physics = TankPhysics.new(self,object_pool)
    @graphics = TankGraphics.new(self)
    @sounds = TankSounds.new(self)
    @direction = @gun_angle = 0.0
  end

  def shoot(target_x, target_y)
    if Gosu.milliseconds - @last_shot > SHOOT_DELAY
      @last_shot = Gosu.milliseconds
      Bullet.new(object_pool, @x, @y, target_x, target_y).fire(100)
    end
  end
end
