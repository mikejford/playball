require 'artoo/robot'

class SpheroRobot < Artoo::Robot
  attr_accessor :sides, :speed, :rolltime, :stoptime

  connection :sphero, :adaptor => :sphero
  device :sphero, :driver => :sphero

  HEADING_MIN = 0
  HEADING_MAX = 360

  def initialize(params={})
    super(params)

    params = defaults.merge(params)
    @sides = params[:sides]
    @speed = params[:speed]
    @rolltime = params[:rolltime]
    @stoptime = params[:stoptime]
  end

  def defaults
    {
      :sides => 3,
      :speed => 150,
      :rolltime => 2,
      :stoptime => 0.1,
    }
  end

  def make_polygon
    side_range.each do |side|
      do_side(side * heading_interval)
    end
  end

  def do_side(heading)
    sphero.roll speed, heading
    sphero.keep_going rolltime

    sphero.stop
    sphero.keep_going stoptime
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


# circle
# {
# :sides => 36,
#   :speed => 150,
#   :rolltime => 0.25
# }

# square
# {
# :sides => 4,
# }
