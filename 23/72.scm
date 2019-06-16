; Exercise 2.72.  Consider the encoding procedure that you designed in exercise 2.68. What is the order of growth in the number of steps needed to encode a symbol? Be sure to include the number of steps needed to search the symbol list at each node encountered. To answer this question in general is difficult. Consider the special case where the relative frequencies of the n symbols are as described in exercise 2.71, and give the order of growth (as a function of n) of the number of steps needed to encode the most frequent and least frequent symbols in the alphabet.

; Let's consider that special case.
; In worst case, we make (n-1) steps down the tree. On each step we examine from n to 1 elements in branches of current node. Topmost node contains n elements in its branches, next contains (n-1) and so on, so on average each node contains n/2 elements. Сomplexity is O(n^2): (n-1) steps down the tree * n/2 elements on each step.
; In best case, we make 1 step down the tree. On that step we examine n elements in branches of topmost node. Сomplexity is O(n): 1 step down the tree * n elements on that step.
