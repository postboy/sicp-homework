; Exercise 2.71.  Suppose we have a Huffman tree for an alphabet of n symbols, and that the relative frequencies of the symbols are 1, 2, 4, ..., 2^(n-1). Sketch the tree for n=5; for n=10. In such a tree (for general n) how many bits are required to encode the most frequent symbol? the least frequent symbol?

(load "69.scm")

; For brevity, numbers below is powers of 2, i.e. 4 stands for 2^4.

; n = 5
;          node
;       node  4
;    node  3
; node  2
; 0  1

; n = 10
;                         node
;                      node  9
;                   node  8
;                node  7
;             node  6
;          node  5
;       node  4
;    node  3
; node  2
; 0  1

; Let's prove it on a toy example:
(define pow2-example '((A 1) (B 2) (C 4) (D 8)))
(define pow2-tree '((((leaf a 1) (leaf b 2) (a b) 3) (leaf c 4) (a b c) 7) (leaf d 8) (a b c d) 15))
(assert (generate-huffman-tree pow2-example) pow2-tree)

; Why do trees look like this? Because 2^n - 1 = sum of 2^x, where x=0..(n-1), i.e. 2^n > sum of 2^x, where x=0..(n-1).

; Such tree encodes most common symbol with 1 bit and least common symbol with (n-1) bits (or 1 bit if n = 0 or n = 1).
