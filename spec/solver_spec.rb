require 'spec_helper'

describe Solver do
  

  describe Solver::Board do
    it 'should parse that shit' do
      puzzle = format_puzzle %q(
        3 4
        0 0 N
        0 1 /
        0 2 \
      )
      board = Solver::Board.new(puzzle)

      expect( board.to_s    ).to eq puzzle
      expect( board.width   ).to eq 3
      expect( board.height  ).to eq 4
      expect( board.player  ).to eq Solver::Position.new(0, 0, :N)
      expect( board.mirrors ).to eq [
        Solver::Cell.new(0,1,:/),
        Solver::Cell.new(0,2,:'\\')
      ]
    end
  end

  it 'should take a puzzle as a string and parse it' do
    puzzle = format_puzzle %q(
      3 3
      0 0 N
      0 1 /
      0 2 \
    )

    solver = Solver.new(puzzle)
    
    expect( solver.board.to_s             ).to eq puzzle
    expect( solver.board.width            ).to eq 3
    expect( solver.board.height           ).to eq 3
    expect( solver.board.player.x         ).to eq 0
    expect( solver.board.player.y         ).to eq 0
    expect( solver.board.player.direction ).to eq :N
    expect( solver.board.mirrors          ).to eq [
      Solver::Cell.new(0,1,:/),
      Solver::Cell.new(0,2,:'\\')
    ]
  end



  def format_puzzle(puzzle)
    puzzle.split("\n").map(&:strip).reject(&:empty?).join("\n")
  end


end
