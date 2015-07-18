class Solver

  Cell = Struct.new(:board, :x, :y) do
    def mirror
      board.mirror(x, y)
    end
  end

  Position = Struct.new(:board, :cell, :direction) do
    def x; cell.x; end
    def y; cell.y; end
    def next
      next_x, next_y = case direction
        when :N; [cell.x,   cell.y-1]
        when :S; [cell.x,   cell.y+1]
        when :E; [cell.x+1, cell.y  ]
        when :W; [cell.x-1, cell.y  ]
        else; binding.pry
      end

      next_cell = board.cell(next_x, next_y)

      next_direction = case [next_cell.mirror, direction]
        when [nil,  :N]; :N
        when [nil,  :S]; :S
        when [nil,  :E]; :E
        when [nil,  :W]; :W
        when [:'/', :N]; :E
        when [:'/', :S]; :W
        when [:'/', :E]; :N
        when [:'/', :W]; :S
        when [:'\\',:N]; :W
        when [:'\\',:S]; :E
        when [:'\\',:E]; :S
        when [:'\\',:W]; :N
        else; binding.pry
      end
      self.class.new(board, next_cell, next_direction)
    end
  end


  class Board

    DIRECTIONS = [:N, :S, :E, :W].freeze

    InvalidCellError = Class.new(StandardError)
    ParseError = Class.new(StandardError)
    InvalidDirectionError = Class.new(StandardError)

    attr_reader :to_s, :width, :height, :player

    def initialize(puzzle)
      @to_s = puzzle
      lines = puzzle.split("\n")
      lines.shift.match(%r<^(\d+) (\d+)$>) or raise ParseError.new('failed to parse board size')
      @width, @height = $1.to_i, $2.to_i

      lines.shift.match(%r<^(\d+) (\d+) ([NSEW])$>) or raise ParseError.new('failed to parse player position')
      @player = position($1.to_i, $2.to_i, $3.to_sym)

      @mirrors = {}
      lines.each do |line|
        line.match(%r<^(\d+) (\d+) ([\/\\])$>) or raise ParseError.new('failed to parse mirror position')
        @mirrors[[$1.to_i, $2.to_i]] = $3.to_sym
      end
      @mirrors.freeze
    end

    def mirror(x, y)
      @mirrors[[x,y]]
    end

    def cell(x, y)
      if x < 0 || x >= width || y < 0 || y >= height
        raise InvalidCellError.new("#{x},#{y} is an invalid cell")
      end
      Cell.new(self, x, y)
    end

    def position(x, y, direction)
      if !DIRECTIONS.include?(direction)
        raise InvalidDirectionError, "#{direction.inspect} is not a valid direction"
      end
      Position.new(self, cell(x, y), direction)
    end
  end

  attr_reader :board, :solution

  def initialize(puzzle)
    @board = Board.new(puzzle)
    @path = []
    solve!
  end

  private

  def solve!
    @lazer_position = board.player.dup
    loop do
      return @solution = '-1' if @path.include? @lazer_position
      @path << @lazer_position
      begin
        @lazer_position = @lazer_position.next
      rescue Solver::Board::InvalidCellError
        return @solution = "#{@path.length}\n#{@path.last.x} #{@path.last.y}"
      end
    end
  end

end