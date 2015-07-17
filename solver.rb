class LazerMaaazzeeSolver

  def initialize(puzzle)
    @puzzle = puzzle
    lines = puzzle.split("\n")
    @size_x, @size_y = lines.shift.split(' ').map(&:to_i)
    @player_x, @player_y, @player_direction = lines.shift.split(' ')
    @player_x, @player_y = @player_x.to_i, @player_y.to_i
    @mirrors = lines.map do |line|
      x, y, direction = line.split(' ')
      [x.to_i, y.to_i, direction]
    end
  end

  def solution
    @solution ||= solve!
  end

  def solve!
    lazer_x, lazer_y, lazer_direction = @player_x, @player_y, @player_direction
    path = []
    loop do
      next_path = [lazer_x, lazer_y, lazer_direction]
      return '-1' if path.include?(next_path)
      path.push next_path
      next_x, next_y = case lazer_direction
        when 'N'; [lazer_x, lazer_y-1]
        when 'S'; [lazer_x, lazer_y+1]
        when 'E'; [lazer_x+1, lazer_y]
        when 'W'; [lazer_x-1, lazer_y]
      end

      next_cell = cell_for(next_x, next_y)
      break if next_cell.nil?

      next_direction = case [next_cell,lazer_direction]
        when ['',  'N']; 'N' 
        when ['',  'S']; 'S' 
        when ['',  'E']; 'E' 
        when ['',  'W']; 'W' 
        when ['/', 'N']; 'E'
        when ['/', 'S']; 'W'
        when ['/', 'E']; 'N'
        when ['/', 'W']; 'S'
        when ['\\','N']; 'W'
        when ['\\','S']; 'E'
        when ['\\','E']; 'S'
        when ['\\','W']; 'N'
      end
      lazer_x, lazer_y, lazer_direction = next_x, next_y, next_direction
    end
    "#{path.length}\n#{path.last[0]} #{path.last[1]}"
  end

  private

  def cell_for(x, y)
    return nil if x > (@size_x-1) || y > (@size_y-1)
    @mirrors.each do |(mx, my, mirror)|
      return mirror if x == mx && y == my
    end
    return ""
  end

  def mirror?(x, y)
    @mirrors.each do |(mx, my, direction)|
      return direction if x == mx && y == my
    end
  end

end