require 'pathname'
require 'pry-byebug'
ROOT = Pathname File.expand_path('..', __FILE__)
require ROOT + 'solver'

TEST_CASES = []

Dir[ROOT+'puzzles/puzzle*'].each do |puzzle_file|
  index = puzzle_file.match(%r{/puzzle(\d+)})[1].to_i
  puzzle_file = Pathname(puzzle_file)
  TEST_CASES[index] = {
    puzzle:   puzzle_file.read,
    solution: puzzle_file.join("../solution#{index}").read,
  }.freeze
end

TEST_CASES.freeze

p TEST_CASES

failed = false

TEST_CASES.each_with_index do |testcase, index|
  next if testcase.nil?
  solver = LazerMaaazzeeSolver.new(testcase[:puzzle])
  solution = solver.solution
  if solution != testcase[:solution]
    failed = true
    warn "Test case #{index} failed!"
    warn "EXPECTED:\n#{solution}\nTO EQUAL:\n#{testcase[:solution]}\n"
  end
end

exit(failed ? 1 : 0)
