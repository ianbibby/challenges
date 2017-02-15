def word_ladder(begin_word, end_word, word_list)
  graph = build_graph(begin_word, word_list)

  distances = Hash.new(0)
  visited = {}
  queue = [begin_word]

  depth = 0
  while queue.any?
    word = queue.shift
    visited[word] = true

    return distances[word]+1 if word == end_word

    graph[word].each do |edge|
      next if distances.key?(edge) || visited[edge]
      queue << edge
      distances[edge] = distances[word] + 1
    end

    depth += 1
  end

  return 0
end

def generate_keys(word)
  keys = []
  word.size.times do |i|
    tmp = word.clone
    tmp[i] = "_"
    keys << tmp
  end
  keys
end

def build_graph(begin_word, word_list)
  default_hash_value = -> h,k { h[k] = [] }

  h = Hash.new(&default_hash_value)

  word_list.unshift(begin_word)
  word_list.each do |word|
    generate_keys(word).each do |k|
      h[k] << word
    end
  end

  g = Hash.new(&default_hash_value)
  h.each do |k,v|
    v.permutation(2) do |w1,w2|
      next if w1 == w2
      g[w1] << w2
    end
  end

  g
end

shortest_path = word_ladder "hit", "cog", %w(hot dot dog lot log cog)

puts shortest_path
