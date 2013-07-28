require 'artoo/robot'

class SpheroRobot < Artoo::Robot
  attr_accessor :sides, :speed, :rolltime, :stoptime

  connection :sphero, :adaptor => :sphero
  device :sphero, :driver => :sphero

  HEADING_MIN = 0
  HEADING_MAX = 360

  def initialize(params = {})
    super(params)
    set_shape(params)
  end

  def defaults
    {
      :sides => 3,
      :speed => 100,
      :rolltime => 2,
      :stoptime => 1,
    }
  end

  def set_shape(shape = {})
    shape = defaults.merge(shape)
    
    @sides = shape[:sides]
    @speed = shape[:speed]
    @rolltime = shape[:rolltime]
    @stoptime = shape[:stoptime]
  end

  def make_polygon
    side_range.each do |side|
      do_side(side * heading_interval)
    end
  end

  def do_side(heading)
    sphero.roll speed, heading
    Kernel::sleep rolltime

    sphero.stop
    Kernel::sleep stoptime
  end

  def side_range
    0..(sides - 1)
  end

  def heading_interval
    interval = HEADING_MIN
    unless sides <= 1
      interval = HEADING_MAX / sides
    end
    interval.to_i
  end

  def change_color(color)
    sphero.set_color *color
  end

  def random
    [ rand(255), rand(255), rand(255) ]
  end
end
