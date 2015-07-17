class Solver

  Cell = Struct.new(:x, :y, :mirror)

  Position = Struct.new(:x, :y, :direction) do
    def next
      next_x, next_y = case direction
        when :N; [x, y-1]
        when :S; [x, y+1]
        when :E; [x+1, y]
        when :W; [x-1, y]
      end
      next_direction = 
      Position.new(next_x, next_y, next_direction)
    end
  end


  class Board

    ParseError = Class.new(StandardError)

    attr_reader :to_s, :width, :height, :player, :mirrors

    def initialize(puzzle)
      @to_s = puzzle
      lines = puzzle.split("\n")
      lines.shift.match(%r<^(\d+) (\d+)$>) or raise ParseError.new('failed to parse board size')
      @width, @height = $1.to_i, $2.to_i

      lines.shift.match(%r<^(\d+) (\d+) ([NSEW])$>) or raise ParseError.new('failed to parse player position')
      @player = Position.new($1.to_i, $2.to_i, $3.to_sym)

      @mirrors = lines.map do |line|
        line.match(%r<^(\d+) (\d+) ([\/\\])$>) or raise ParseError.new('failed to parse mirror position')
        Cell.new($1.to_i, $2.to_i, $3.to_sym)
      end.freeze
    end
  end


  # attr_reader :puzzle, :size_x, :size_y, :player_x, :player_y
  # attr_reader :player_direction, :mirrors
  attr_reader :board

  def initialize(puzzle)
    @board = Board.new(puzzle)
    @path = []
    # solve!
  end

  # private

  # def solve!
  #   @lazer_position = @player_position.dup
  #   lazer_x, lazer_y, lazer_direction = @player_x, @player_y, @player_direction
  #   loop do
  #     @next_lazer_position = @lazer_position.next

  #     next_path = [lazer_x, lazer_y, lazer_direction]
  #     return '-1' if @path.include?(next_path)
  #     @path.push next_path
  #     # next_x, next_y = case lazer_direction
  #     #   when 'N'; [lazer_x, lazer_y-1]
  #     #   when 'S'; [lazer_x, lazer_y+1]
  #     #   when 'E'; [lazer_x+1, lazer_y]
  #     #   when 'W'; [lazer_x-1, lazer_y]
  #     # end

  #     next_cell = cell_for(next_x, next_y)
  #     break if next_cell.nil?

  #     next_direction = case [next_cell,lazer_direction]
  #       when ['',  'N']; 'N' 
  #       when ['',  'S']; 'S' 
  #       when ['',  'E']; 'E' 
  #       when ['',  'W']; 'W' 
  #       when ['/', 'N']; 'E'
  #       when ['/', 'S']; 'W'
  #       when ['/', 'E']; 'N'
  #       when ['/', 'W']; 'S'
  #       when ['\\','N']; 'W'
  #       when ['\\','S']; 'E'
  #       when ['\\','E']; 'S'
  #       when ['\\','W']; 'N'
  #     end
  #     lazer_x, lazer_y, lazer_direction = next_x, next_y, next_direction
  #   end
  #   "#{@path.length}\n#{@path.last[0]} #{@path.last[1]}"
  # end

  # def cell_for(x, y)
  #   return nil if x > (@size_x-1) || y > (@size_y-1)
  #   @mirrors.each do |(mx, my, mirror)|
  #     return mirror if x == mx && y == my
  #   end
  #   return ""
  # end

  # def mirror?(x, y)
  #   @mirrors.each do |(mx, my, direction)|
  #     return direction if x == mx && y == my
  #   end
  # end

end