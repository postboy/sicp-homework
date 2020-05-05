; Exercise 3.54.  Define a procedure mul-streams, analogous to add-streams, that produces the elementwise product of its two input streams. Use this together with the stream of integers to complete the following definition of the stream whose nth element (counting from 0) is n + 1 factorial: <...>.

(load "ch35_common.scm")

(define (mul-streams s1 s2)
  (stream-map * s1 s2))

(define factorials (cons-stream 1
				(mul-streams factorials
					     (stream-cdr integers))))

(assert (stream-ref factorials 0) 1) ; fact(1) = hardcoded = 1
(assert (stream-ref factorials 1) 2) ; fact(2) = fact[0] * int[1] = 1*2 = 2
(assert (stream-ref factorials 2) 6) ; fact(3) = fact[1] * int[2] = 2*3 = 6
(assert (stream-ref factorials 3) 24)
