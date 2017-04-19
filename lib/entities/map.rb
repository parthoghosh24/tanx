require 'perlin_noise'
require 'gosu_texture_packer'

class Map
  MAP_WIDTH=100
  MAP_HEIGHT=100
  TILE_SIZE=128
  attr_accessor :objects

  def initialize
    load_tiles
    @map = generate_map
    @objects = []
  end

  def find_spawn_point
    while true
      x = rand(0..MAP_WIDTH * TILE_SIZE)
      y = rand(0..MAP_HEIGHT * TILE_SIZE)
      if can_move_to?(x,y)
        return [x,y]
      else
        puts "Invalid spawn point: #{[x,y]}"
      end
    end
  end

  def can_move_to?(x,y)
    tile = tile_at(x,y)
    tile && tile != @water
  end

  def draw(viewport)
    puts "viewport #{viewport}"
    viewport.map! {|p| p/TILE_SIZE}
    x0,x1,y0,y1 = viewport.map(&:to_i)
    (x0..x1).each do |x|
      (y0..y1).each do |y|
        row = @map[x]
        if row
          tile = @map[x][y]
          map_x = x * TILE_SIZE
          map_y = y * TILE_SIZE
          tile.draw(map_x,map_y,0) if tile
        end
      end
    end
  end

  private

  def tile_at(x,y)
    tile_x = ((x/TILE_SIZE)%TILE_SIZE).floor
    tile_y = ((y/TILE_SIZE)%TILE_SIZE).floor
    row = @map[tile_x]
    row[tile_y] if row
  end

  def load_tiles
    tiles = Gosu::Image.load_tiles($window,Utils.media_path('ground.png'),128,128,true)
    @sand = tiles[0]
    @grass = tiles[8]
    @water = Gosu::Image.new($window,Utils.media_path('water.png'),true)
  end

  def generate_map
    noises = Perlin::Noise.new 2
    contrast = Perlin::Curve.contrast(Perlin::Curve::CUBIC,2)
    map = {}
    MAP_WIDTH.times do |x|
      map[x]={}
      MAP_HEIGHT.times do |y|
        noise = noises[x*0.1,y*0.1]
        noise = contrast.call(noise)
        map[x][y]=choose_tile(noise)
      end
    end
    map
  end

  def choose_tile(val)
    case val
    when 0.0..0.3 # 30 % water chance
      @water
    when 0.3..0.45 # 15 % chance, water edges
      @sand
    else # 55 % chance grass
      @grass
    end
  end



end
