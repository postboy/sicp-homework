; Exercise 3.67.  Modify the pairs procedure so that (pairs integers integers) will produce the stream of all pairs of integers (i,j) (without the condition i =< j). Hint: You will need to mix in an additional stream.

(load "ch35_common.scm")

(define (pairs s t)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (interleave
    (stream-map (lambda (x) (list (stream-car s) x))
                (stream-cdr t))
    (interleave
     (stream-map (stream-cdr s)
		 (lambda (x) (list x (stream-car t))))
     (pairs (stream-cdr s) (stream-cdr t))))))

(define int-pairs (pairs integers integers))
(assert (stream-head int-pairs 15) '((1 1) (1 2) (2 1) (1 3) (2 2) (1 4) (3 1) (1 5) (2 3) (1 6) (4 1) (1 7) (3 2) (1 8) (5 1)))
