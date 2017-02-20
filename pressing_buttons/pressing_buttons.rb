# O(n choose k)

def pressing_buttons(buttons)
  return [] if buttons.empty?

  map = {
    2 => "abc", 3 => "def", 4 => "ghi",
    5 => "jkl", 6 => "mno", 7 => "pqrs",
    8 => "tuv", 9 => "wxyz"
  }

  combinations = []
  letters = buttons.each_char.map { |b| map[b.to_i] }
  find_combinations(letters, "", 0, letters.size, combinations)

  combinations.sort!
end

def find_combinations(letters, combination, l, r, combinations)
  if l == r
    combinations << combination.clone
  else
    letters[l].each_char do |c|
      combination << c
      find_combinations(letters, combination, l+1, r, combinations)
      combination.slice!(-1)  # backtrack
    end
  end
end

puts pressing_buttons("42") == %w{ga gb gc ha hb hc ia ib ic } ? "Passed" : "Failed"

