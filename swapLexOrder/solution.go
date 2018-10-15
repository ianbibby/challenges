package main

import (
	"fmt"
	"sort"
)

func main() {
	fmt.Println(swapLexOrder("abdc", [][]int{
		[]int{1, 4},
		[]int{3, 4},
	}))
}

// Set allows for Adding and Clearing a hash set.
// Also returns the elements as a sorted list.
type Set map[int]struct{}

func (s Set) Add(values ...int) {
	for _, n := range values {
		if _, ok := s[n]; !ok {
			s[n] = struct{}{}
		}
	}
}
func (s Set) Clear() {
	for k := range s {
		delete(s, k)
	}
}
func (s Set) SortedSlice() []int {
	keys := make([]int, 0, len(s))
	for k := range s {
		keys = append(keys, k)
	}
	sort.Ints(keys)
	return keys
}

func swapLexOrder(str string, pairs [][]int) string {
	if len(str) == 1 || len(pairs) == 0 {
		return str
	}

	// Go routine for tracking connected pairs.
	elMap := make(map[int]int)
	merged := []Set{}
	mergeCh := make(chan []int, 0)
	stopMergeCh := make(chan struct{}, 0)
	go func() {
		for {
			select {
			case <-stopMergeCh:
				close(mergeCh)
				close(stopMergeCh)
				return
			case pair := <-mergeCh:
				// Zero-base the pair
				for i := range pair {
					pair[i] = pair[i] - 1
				}

				existing := []int{}
				// Check each pair element for existing groups
				for _, v := range pair {
					if n, ok := elMap[v]; ok {
						existing = append(existing, n)
					}
				}

				// Add new, or merge existing connections
				if len(existing) == 0 {
					set := Set{}
					set.Add(pair...)
					merged = append(merged, set)
					bkt := len(merged) - 1
					for _, v := range pair {
						elMap[v] = bkt
					}
				} else {
					// TODO Determine which is the smallest existing bucket for efficiency?
					first := merged[existing[0]]
					first.Add(pair...)
					// Memo the group of new pair
					for _, v := range pair {
						elMap[v] = existing[0]
					}

					if len(existing) > 1 && existing[1] != existing[0] {
						// Migrate & clear the other group
						other := merged[existing[1]]
						for n := range other {
							elMap[n] = existing[0]
							first.Add(n)
						}
						other.Clear()
					}

				}
			}
		}
	}()

	// Merge pairs
	for _, p := range pairs {
		mergeCh <- p
	}
	stopMergeCh <- struct{}{}

	bStr := []byte(str)
	// Iterate through each connected group.
	// Lexicographically sort the characters within each group.
	for _, set := range merged {
		idxs := set.SortedSlice()

		for i := 0; i < len(idxs)-1; i++ {
			for j := i; j < len(idxs); j++ {
				a, b := idxs[i], idxs[j]
				if bStr[a] < bStr[b] {
					bStr[a], bStr[b] = bStr[b], bStr[a]
				}
			}
		}
	}

	return string(bStr)
}
