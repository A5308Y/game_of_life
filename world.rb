require_relative 'cell'

class World
  attr_accessor :cells

  def initialize
    @cells = []
  end

  def to_s
    render
  end

  def add_cells(cells = [])
    @cells += cells
  end

  def add_cell(cell)
    @cells << cell
  end

  def neighbours_for(position)
    @cells.select do |cell|
      cell.position != position &&
      (cell.position[0] - position[0]).abs <= 1 &&
      (cell.position[1] - position[1]).abs <= 1
    end
  end

  def populate(x_max, y_max)
    @width = x_max
    (1..x_max).each do |x_coordinate|
      (1..y_max).each do |y_coordinate|
        Cell.new(world: self, position: [x_coordinate, y_coordinate], alive: [true, false].sample)
      end
    end
  end

  def set_neighbours
    @cells.each(&:set_neighbours)
  end

  def process_turn
    @cells.each(&:set_live_neighbour_count)
    @cells.each(&:process_turn)
    self
  end

  def render
    @cells.map{ |cell| cell.alive? ? 'x' : '.' }.join.scan(/.{#{@width}}/).join("\n")
  end
end
