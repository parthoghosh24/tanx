class TankGraphics < Component
  DEBUG_COLORS = [Gosu::Color::RED,Gosu::Color::BLUE,Gosu::Color::YELLOW,Gosu::Color::WHITE].freeze
  def initialize(game_object)
    super(game_object)
    @body_normal = units.frame('tank1_body.png')
    @shadow_normal = units.frame('tank1_body_shadow.png')
    @gun_normal = units.frame('tank1_dualgun.png')
    @body_dead = units.frame('tank1_body_destroyed.png')
    @shadow_dead = units.frame('tank1_body_destroyed_shadow.png')
    @gun_dead = nil
  end

  def update
    if object.health.dead?
      @body = @body_dead
      @shadow = @shadow_dead
      @gun = @gun_dead
    else
      @body = @body_normal
      @shadow = @shadow_normal
      @gun = @gun_normal
    end
  end

  def draw(viewport)
    @shadow.draw_rot(x-1,y-1,0,object.direction)
    @body.draw_rot(x,y,1,object.direction)
    @gun.draw_rot(x,y,2,object.gun_angle) if @gun
    # draw_bounding_box
  end

  def draw_bounding_box
    index  = 0
    object.box.each_slice(2) do |x,y|
      color = DEBUG_COLORS[index]
      $window.draw_triangle(
      x-3, y-3, color,
      x, y, color,
      x+3, y-3, color,
      100)
      index =  (index + 1) % 4
    end
  end

  def width
    @body.width
  end

  def height
    @body.height
  end

  private

  def units
    @@units = Gosu::TexturePacker.load_json($window,Utils.media_path('ground_units.json'), :precise)
  end
end
