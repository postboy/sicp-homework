; Exercise 3.55.  Define a procedure partial-sums that takes as argument a stream S and returns the stream whose elements are S0, S0 + S1, S0 + S1 + S2, .... For example, (partial-sums integers) should be the stream 1, 3, 6, 10, 15, ....

(load "ch35_common.scm")

(define (partial-sums s)
  (define internal-stream (cons-stream (stream-car s)
				       (add-streams internal-stream
						    (stream-cdr s))))
  internal-stream)

(define part-sums-int (partial-sums integers))
(assert (stream-ref part-sums-int 0) 1) ; int[0] = 1
(assert (stream-ref part-sums-int 1) 3) ; psi[0] + int[1] = 1 + 2 = 3
(assert (stream-ref part-sums-int 2) 6) ; psi[1] + int[2] = 3 + 3 = 6
(assert (stream-ref part-sums-int 3) 10)
(assert (stream-ref part-sums-int 4) 15)
