# You are given a grid with both sides equal to . Rows and columns are numbered from  to .
# There is a castle on the intersection of the th row and the th column.
#
# Your task is to calculate the minimum number of steps it would take to move the castle
# from its initial position to the goal position ().
#
# It is guaranteed that it is possible to reach the goal position from the initial position.
#
# Note: You can move the castle from cell  to any  in a single step if there is a straight
# line between and  that does not contain any forbidden cell. Here, "X" denotes a forbidden cell.
#
# Input Format
#
# The first line contains an integer , the size of the grid.
#
# The following  lines contains a string of length  that consists of one of the following
# characters: "X" or ".". Here, "X" denotes a forbidden cell, and "." denotes an allowed cell.
#
# The last line contains , , denoting the initial position of the castle, and , , denoting
# the goal position. Here,  and  are space separated.
#
# Constraints
#
#  Output Format
#
#  Output a single line: The integer denoting the minimum number of steps required to move
#  the castle to the goal position.
#
#  Sample Input
#
#  3
#  .X.
#  .X.
#  ...
#  0 0 0 2
#  Sample Output
#
#  3
#
class Cell

  class << self
    attr_accessor :size
  end

  attr_reader :vertex

  def initialize(row, col, forbidden=false)
    @vertex = [row, col]
    @forbidden = forbidden
  end

  def forbidden?
    @forbidden
  end

  def neighbors
    row,col = @vertex
    result = []
    result << Cell.new(row-1, col) if row > 0
    result << Cell.new(row, col+1) if col < Cell.size-1
    result << Cell.new(row+1, col) if row < Cell.size-1
    result << Cell.new(row, col-1) if col > 0
    result
  end

  def row
    @vertex[0]
  end

  def col
    @vertex[1]
  end

  def to_s
    @vertex
  end

  def hash
    @vertex.hash
  end

  def eql?(other)
    @vertex.eql? other.vertex
  end
end

size = gets.to_i
Cell.size = size

adj = {}
size.times do |row|
  cols = gets
  cols.each_char.with_index { |c,i| adj[Cell.new(row, i, true)] = -1 if c == 'X' }
end

r0, c0, r1, c1 = gets.split(' ').map(&:to_i)

queue = []
visited = {}

root = Cell.new(r0,c0)
goal = Cell.new(r1,c1)

level = 0
adj[root] = level

follow_path = -> cell, row, col do
  neighbor = Cell.new(row, col)
  break false if adj.key?(neighbor) || visited.key?(neighbor)

  queue << neighbor
  adj[neighbor] = adj[cell] + 1

  true
end

queue << root
while queue.any?
  cell = queue.shift
  break if cell.eql? goal
  visited[cell] = true

  (cell.row-1).downto(0) do |row|
    break unless follow_path.call(cell, row, cell.col)
  end
  (cell.col+1).upto(Cell.size-1) do |col|
    break unless follow_path.call(cell, cell.row, col)
  end
  (cell.row+1).upto(Cell.size-1) do |row|
    break unless follow_path.call(cell, row, cell.col)
  end
  (cell.col-1).downto(0) do |col|
    break unless follow_path.call(cell, cell.row, col)
  end

  level += 1
end

puts adj[goal]
