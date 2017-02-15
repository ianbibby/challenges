Given two words, beginWord and endWord, and a wordlist of approved words, find the length of the shortest transformation sequence from beginWord to endWord such that:

Only one letter can be changed at a time
Each transformed word must exist in the wordList.
Return the length of the shortest transformation sequence, or 0 if no such transformation sequence exists.

Note: beginWord does not count as a transformed word. You can assume that beginWord and endWord are not empty and are not the same.

Example

For beginWord = "hit", endWord = "cog", and wordList = ["hot", "dot", "dog", "lot", "log", "cog"], the output should be
wordLadder(beginWord, endWord, wordList) = 5.

The shortest transformation is "hit" -> "hot" -> "dot" -> "dog" -> "cog" with a length of 5.

Input/Output

[time limit] 4000ms (rb)
[input] string beginWord

Constraints:
1 ≤ beginWord.length ≤ 5.

[input] string endWord

Constraints:
endWord.length = beginWord.length.

[input] array.string wordList

An array containing all of the approved words. All words in the array are the same length and contain only lowercase English letters. You can assume that there are no duplicates in wordList.

Constraints:
2 ≤ wordList.length ≤ 600,
wordList[i].length = beginWord.length.

[output] integer

An integer representing the length of the shortest transformation sequence from beginWord to endWord using only words from wordList as described above.
