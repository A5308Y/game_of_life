class Cell
  attr_accessor :position
  def initialize(params = {})
    @world                = params[:world]
    @alive                = params[:alive]
    @alive                = true if params[:alive].nil?
    @position             = params[:position]
    @live_neighbour_count = 0
    @neighbours           = []
    @world.add_cell(self) if @world
  end

  def live_neighbours
    @neighbours.select(&:alive?)
  end

  def set_neighbours
    @neighbours = @world.neighbours_for(@position)
  end

  def set_live_neighbour_count
    @live_neighbour_count = live_neighbours.count
  end

  def alive?
    @alive
  end

  def dead?
    !alive?
  end

  def process_turn
    set_live_neighbour_count
    die unless [2, 3].include? @live_neighbour_count
    become_alive if @live_neighbour_count == 3
  end

  private

  def become_alive
    @alive = true
  end

  def die
    @alive = false
  end
end
