require_relative 'game.rb'
require 'rainbow/refinement'
using Rainbow

# Pegs Tests
RSpec.describe Pegs do
  describe '#create_pegs' do
    context 'when provided a valid char' do
      subject(:peg) { described_class.new 'y' }
      it 'returns a peg string' do
        expect(peg.chip).to eql("◉".yellow)
      end
    end

    context 'when provided an invalid input' do
      subject(:peg) { described_class.new 'Invalid Peg Code' }
      it 'returns nil' do
        expect(peg.chip).to be_nil
      end
    end
  end
end

# Board Tests
RSpec.describe Board do
  describe '#to_s' do

    context 'when the board is empty' do
      subject(:board) { described_class.new }
      it 'prints the board' do
        empty_board = "❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘\n❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘\n❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘\n❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘\n❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘\n❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘\n"
        expect { puts board }.to output(empty_board).to_stdout
      end
    end

    context 'when the board is not empty' do
      subject(:board) { described_class.new }
      let(:player) { Player.new 'Yob', board }
      it 'prints the board' do
        index = 6
        2.times { player.place_chip 'y', index }
        board_str = "❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘\n❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘\n❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘\n❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘\n❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘❘#{"◉".yellow}❘\n❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘❘ ❘❘#{"◉".yellow}❘\n"
        expect { puts board }.to output(board_str).to_stdout
      end
    end


  end

  describe '#column_height' do
    context 'when given a valid column index' do
      subject(:board) { described_class.new }
      let(:player) { Player.new 'Rob', board }
      it 'returns its size' do
        index = 4
        3.times { player.place_chip 'y', index }
        result = board.column_height index
        expect(result).to eql 3
      end
    end
  end

  describe '#get_column' do
    context 'when given a valid column index' do
      subject(:board) { described_class.new }
      let(:player) { Player.new 'Job', board }
      it 'returns a column array' do
        index = 5
        2.times { player.place_chip 'y', index }
        result = board.get_column index
        expect(result.map { |peg| peg.nil? ? nil : peg.chip }).to eq(
        ["◉".yellow, "◉".yellow, nil, nil, nil, nil])
      end
    end
  end

end

# Player Tests
RSpec.describe Player do
  describe '#place_chip' do

    context 'when the column is not full' do

      subject(:player) { described_class.new 'Bob', board }
      let(:board) { Board.new }

      it 'puts the chip on the board' do
        index = 5
        player.place_chip 'y', index
        expect(board.grid[0][5]).not_to be_nil
      end

      it "modifies chip's address" do
        index = 5
        player.place_chip 'y', index
        expect(board.grid[0][5].address).to eql([0,5])
      end


    end

    context 'when the column is full' do
      subject(:player) { described_class.new 'Dob', board }
      let(:board) { Board.new }

      it 'does not add chip to board' do
        index = 5
        6.times { player.place_chip 'y', index }
        expect{ player.place_chip 'y', index }.not_to change(board, :grid)
      end

    end

    context 'when trying to play outside the grid' do
      subject(:player) { described_class.new 'Dob', board }
      let(:board) { Board.new }

      it 'does nothing' do
        index = 7
        expect{ player.place_chip 'y', index }.not_to change(board, :grid)
      end

    end


  end
end

# Rules Tests
RSpec.describe Rules do

  describe '#winner' do

    context 'when the board has a win condition' do
      subject(:rules) { described_class.new board }
      let(:board) { Board.new }
      let(:player) { Player.new 'Ann', board }

      it "returns the last move's player" do
        index = 1
        4.times { player.place_chip 'y', index }
        result = rules.winner
        expect(result).to eql('Ann')
      end

    end

    context 'when the board does not have a win condition' do
      subject(:rules) { described_class.new board }
      let(:board) { Board.new }
      let(:player) { Player.new 'Jess', board }

      it "returns the last move's player" do
        index = 1
        3.times { player.place_chip 'y', index }
        result = rules.winner
        expect(result).to eql(nil)
      end

    end

  end

  describe '#tie?' do
    context 'when the board is full' do
      subject(:rules) { described_class.new board }
      let(:board) { Board.new }
      let(:player) { Player.new 'Jess', board }

      it 'returns true' do
        i = 0
        loop do
          6.times { player.place_chip 'y', i }
          i+=1
          break if i==7
        end
        result = rules.tie?
        expect(result).to eql(true)
      end
    end

    context 'when the board is not full' do
      subject(:rules) { described_class.new board }
      let(:board) { Board.new }
      let(:player) { Player.new 'Jess', board }

      it 'returns false' do
        i = 0
        loop do
          n = i==6 ? 5 : 6
          n.times { player.place_chip 'y', i }
          i+=1
          break if i==7
        end
        result = rules.tie?
        expect(result).to eql(false)
      end
    end

  end

  describe '#game_over?' do

    context 'when there is a tie' do
      subject(:rules) { described_class.new board }
      let(:board) { Board.new }
      let(:player) { Player.new 'Jess', board }

      it 'returns true' do
        allow(rules).to receive(:tie?).and_return(true)
        result = rules.game_over?
        expect(result).to eql(true)
      end
    end

    context 'when there is a winner' do
      subject(:rules) { described_class.new board }
      let(:board) { Board.new }
      let(:player) { Player.new 'Jess', board }

      it 'returns true' do
        allow(rules).to receive(:winner).and_return('Josh')
        result = rules.game_over?
        expect(result).to eql(true)
      end
    end

    context 'when there is neither a winner nor a tie' do
      subject(:rules) { described_class.new board }
      let(:board) { Board.new }
      let(:player) { Player.new 'Jess', board }

      it 'returns false' do
        allow(rules).to receive(:winner).and_return(nil)
        allow(rules).to receive(:tie?).and_return(false)
        result = rules.game_over?
        expect(result).to eql(false)
      end
    end

  end

end
