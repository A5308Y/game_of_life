require 'rspec'
require_relative '../cell'
require_relative '../world'

describe Cell do
  let(:world) { World.new }
  let(:cell)  { Cell.new(world: world, position: [0, 0]) }

  context 'A new cell' do
    it 'is alive' do
      Cell.new.should be_alive
    end

    it 'can be assigned a position' do
      Cell.new(position: [50, 50]).position.should == [50, 50]
    end
  end

  describe '#live_neighbours' do
    it 'returns cells which position differs by 1 on the first coordinate' do
      live_neighbour = Cell.new(world: world, position: [1, 0])
      cell.set_neighbours

      cell.live_neighbours.should == [live_neighbour]
    end

    it 'returns cells which position differs by 1 on the second coordinate' do
      live_neighbour = Cell.new(world: world, position: [0, 1])
      cell.set_neighbours

      cell.live_neighbours.should == [live_neighbour]
    end

    it 'returns cells which position differs by 1 on the first coordinate and by 1 on the second coordinate' do
      live_neighbour = Cell.new(world: world, position: [1, 1])
      cell.set_neighbours

      cell.live_neighbours.should == [live_neighbour]
    end

    context 'the cell is sorrounded by other live cells' do
      it 'returns all eight sorrounding cells' do
        live_neighbours = []
        live_neighbours << Cell.new(world: world, position: [-1, -1])
        live_neighbours << Cell.new(world: world, position: [-1, 0])
        live_neighbours << Cell.new(world: world, position: [-1, 1])
        live_neighbours << Cell.new(world: world, position: [0, 1])
        live_neighbours << Cell.new(world: world, position: [1, 1])
        live_neighbours << Cell.new(world: world, position: [1, 0])
        live_neighbours << Cell.new(world: world, position: [1, -1])
        live_neighbours << Cell.new(world: world, position: [0, -1])

        cell.set_neighbours

        cell.live_neighbours.should =~ live_neighbours
      end

      context 'the cell is sorrounded by live and dead cells' do
        it 'only returns the living ones' do
          live_neighbours = []
          live_neighbours << Cell.new(world: world, position: [-1, -1], alive: true)
          live_neighbours << Cell.new(world: world, position: [-1, 0], alive: true)
          live_neighbours << Cell.new(world: world, position: [-1, 1], alive: true)
          Cell.new(world: world, position: [0, 1], alive: false)
          Cell.new(world: world, position: [1, 1], alive: false)
          Cell.new(world: world, position: [1, 0], alive: false)
          Cell.new(world: world, position: [1, -1], alive: false)
          Cell.new(world: world, position: [0, -1], alive: false)

          cell.set_neighbours

          cell.live_neighbours.should =~ live_neighbours
        end
      end
    end

    context 'There are other cells not next to the cells' do
      it 'returns only the sorrounding cells' do
        live_neighbours = []
        live_neighbours << Cell.new(world: world, position: [-1, -1])
        Cell.new(world: world, position: [10, 0])
        Cell.new(world: world, position: [112, 1])
        Cell.new(world: world, position: [0, -2])

        cell.set_neighbours

        cell.live_neighbours.should =~ live_neighbours
      end
    end
  end

  describe 'under-population' do
    context 'A live cell with no live live_neighbours' do
      it 'dies' do
        cell.set_neighbours

        cell.process_turn

        cell.should be_dead
      end
    end

    context 'A live cell with one live live_neighbour' do
      it 'dies' do
        cell.set_neighbours

        cell.process_turn

        cell.should be_dead
      end
    end
  end

  describe 'living on to the next generation' do
    context 'A live cell with two live live_neighbours' do
      before do
        [[0, 1], [1, 0]].each do |tuple|
          Cell.new(world: world, position: tuple)
        end
      end

      it 'lives' do
        cell.set_neighbours

        cell.process_turn

        cell.should be_alive
      end
    end

    context 'A live cell with three live live_neighbours ' do
      before do
        [[0, 1], [1, 0], [1, 1]].each do |tuple|
          Cell.new(world: world, position: tuple)
        end
      end

      it 'lives' do
        cell.set_neighbours

        cell.process_turn

        cell.should be_alive
      end
    end
  end

  describe 'overcrowding' do
    context 'A live cell with four live_neighbours' do
     before do
        [[0, 1], [1, 0], [1, 1], [-1, -1]].each do |tuple|
          Cell.new(world: world, position: tuple)
        end
      end

      it 'dies' do
        cell.set_neighbours

        cell.process_turn

        cell.should be_dead
      end
    end

    context 'A live cell with eight live_neighbours' do
      it 'dies' do
        cell.set_neighbours

        cell.process_turn

        cell.should be_dead
      end
    end
  end

  describe 'reproduction' do
    context 'A dead cell, with three live_neighbours' do
      before do
        cell.send(:die)
        [[0, 1], [1, 0], [1, 1]].each do |tuple|
          Cell.new(world: world, position: tuple)
        end
      end

      it 'becomes alive' do
        cell.set_neighbours
        cell.process_turn

        cell.should be_alive
      end
    end
  end
end
