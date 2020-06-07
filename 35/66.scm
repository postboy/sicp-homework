; Exercise 3.66.  Examine the stream (pairs integers integers). Can you make any general comments about the order in which the pairs are placed into the stream? For example, about how many pairs precede the pair (1,100)? the pair (99,100)? the pair (100,100)? (If you can make precise mathematical statements here, all the better. But feel free to give more qualitative answers if you find yourself getting bogged down.)

(load "ch35_common.scm")

(define (pairs s t)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (interleave
    (stream-map (lambda (x) (list (stream-car s) x))
                (stream-cdr t))
    (pairs (stream-cdr s) (stream-cdr t)))))

(define int-pairs (pairs integers integers))
(assert (stream-head int-pairs 15) '((1 1) (1 2) (2 2) (1 3) (2 3) (1 4) (3 3) (1 5) (2 4) (1 6) (3 4) (1 7) (2 5) (1 8) (4 4)))

; One half of the stream's elements is taken from the first row, one quarter is taken from the second row and so on.

; Order is about 2*100. We have to compute 100 members of this row, ~100 members of following rows.
(assert (stream-ref int-pairs 197) '(1 100))

; Order is about 4*100. We have to compute 100 members of this row, ~100 members of following rows, ~200 members of previous rows (specifically, first row).
(assert (stream-ref int-pairs 392) '(2 100))

; Order is about 8*100. We have to compute 100 members of this row, ~100 members of following rows, ~600 members of previous rows (specifically, ~200 from second row, ~400 from first row).
(assert (stream-ref int-pairs 778) '(3 100))

; Order is about 16*100. We have to compute 100 members of this row, ~100 members of following rows, ~1400 members of previous rows (specifically, ~200 from third row, ~400 from second row, ~800 from first row).
(assert (stream-ref int-pairs 1542) '(4 100))

; So to calculate (i j) member of the stream we need to calculate about 2^i * j previous members. Well, at least in worst case!
