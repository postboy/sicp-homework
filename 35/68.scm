; Exercise 3.68.  Louis Reasoner thinks that building a stream of pairs from three parts is unnecessarily complicated. Instead of separating the pair (S0,T0) from the rest of the pairs in the first row, he proposes to work with the whole first row, as follows: <...>. Does this work? Consider what happens if we evaluate (pairs integers integers) using Louis's definition of pairs.

(load "ch35_common.scm")

(define (pairs s t)
  (interleave
   (stream-map (lambda (x) (list (stream-car s) x))
               t)
   (pairs (stream-cdr s) (stream-cdr t))))

; This procedure doesn't work in general case.
(define int-pairs (pairs integers integers))
; Aborting!: maximum recursion depth exceeded

; To define int-pairs via pairs, we call interleave. To call interleave, we should first evaluate it's arguments. One of it's arguments is (pairs (stream-cdr s) (stream-cdr t)), so we step into infinite loop because our streams are infinite and there's no bottom of recursion. This is not a tail recursion so call stack gets filled and soon overflows.
