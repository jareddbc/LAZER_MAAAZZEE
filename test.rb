require 'pathname'
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

RESULTS = TEST_CASES.map do |testcase, index|
  next if testcase.nil?
  solution = LazerMaaazzeeSolver.new(testcase[:puzzle]).solution
  if solution != testcase[:solution]
    raise "FAILed to solve test case #{index}"
  end
end
