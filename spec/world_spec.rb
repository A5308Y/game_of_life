require 'rspec'
require_relative '../world.rb'
require_relative '../cell.rb'

describe 'Game of Life' do
  let(:world) { World.new }

  context "A new world" do
    it 'has no cells' do
      world.should have(0).cells
    end
  end

  describe '#populate' do
    it 'creates cell objects' do
      world.populate(1, 1)

      world.cells.first.should be_a Cell
    end

    it 'creates cells with a position' do
      world.populate(1, 1)

      world.cells.first.position.length.should == 2
    end

    it 'has the product of arguments as a number of cells' do
      world.populate(8, 4)

      world.cells.count.should == 32
    end
  end

  describe 'process_turn' do
    it 'sends process_turn to each cell' do
      cell = Cell.new(world: world)

      cell.should_receive(:process_turn)

      world.process_turn
    end
  end

  describe 'Displaying the world' do
    describe ".render" do
      it 'prints the world to the console' do
        world.populate(5, 5)
        world.render.should match /((x|\.){5}\n){4}(x|\.){5}/
      end
    end
  end
end
