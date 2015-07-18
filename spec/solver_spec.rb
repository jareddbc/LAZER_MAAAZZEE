require 'spec_helper'

describe Solver do
  

  describe Solver::Board do
    it 'should parse that shit' do
      puzzle = format_puzzle %q(
        3 4
        0 1 N
        0 2 /
        0 3 \
      )
      board = Solver::Board.new(puzzle)

      expect( board.to_s             ).to eq puzzle
      expect( board.width            ).to eq 3
      expect( board.height           ).to eq 4
      expect( board.player.x         ).to eq 0
      expect( board.player.y         ).to eq 1
      expect( board.player.direction ).to eq :N
      expect( board.mirror(0,0)      ).to eq nil
      expect( board.mirror(0,1)      ).to eq nil
      expect( board.mirror(0,2)      ).to eq :/
      expect( board.mirror(0,3)      ).to eq :'\\'
    end
  end

  it 'should take a puzzle as a string and parse it' do
    puzzle = format_puzzle %q(
      3 3
      0 1 S 
      0 0 /
      0 2 \
      2 0 \
      2 2 /
    )

    solver = Solver.new(puzzle)
    
    expect( solver.board.to_s             ).to eq puzzle
    expect( solver.board.width            ).to eq 3
    expect( solver.board.height           ).to eq 3
    expect( solver.board.player.x         ).to eq 0
    expect( solver.board.player.y         ).to eq 1
    expect( solver.board.player.direction ).to eq :S
    expect( solver.board.mirror(0,0)      ).to eq :/
    expect( solver.board.mirror(0,2)      ).to eq :'\\'
    expect( solver.board.mirror(2,0)      ).to eq :'\\'
    expect( solver.board.mirror(2,2)      ).to eq :/
  end



  def format_puzzle(puzzle)
    puzzle.split("\n").map(&:strip).reject(&:empty?).join("\n")
  end


end
