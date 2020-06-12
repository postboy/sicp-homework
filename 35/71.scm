; Exercise 3.71.  Numbers that can be expressed as the sum of two cubes in more than one way are sometimes called Ramanujan numbers, in honor of the mathematician Srinivasa Ramanujan. Ordered streams of pairs provide an elegant solution to the problem of computing these numbers. To find a number that can be written as the sum of two cubes in two different ways, we need only generate the stream of pairs of integers (i,j) weighted according to the sum i^3 + j^3 (see exercise 3.70), then search the stream for two consecutive pairs with the same weight. Write a procedure to generate the Ramanujan numbers. The first such number is 1,729. What are the next five?

(load "70.scm")

(define (sum-of-cubes p)
  (+ (cube (car p)) (cube (cadr p))))

; if stream has two equal consecutive elements then stream-repeats does cons-stream on this element
(define (stream-repeats s)
  (cond ((stream-null? s) the-empty-stream)
	((stream-null? (stream-cdr s)) the-empty-stream)
	((= (stream-car s) (stream-car (stream-cdr s)))
	 (cons-stream (stream-car s)
		      (stream-repeats (stream-cdr s))))
	(else (stream-repeats (stream-cdr s)))))

(define ramanujan-numbers
  (stream-repeats (stream-map (weighted-pairs integers integers sum-of-cubes)
			      sum-of-cubes)))

(assert (stream-head (weighted-pairs integers integers sum-of-cubes) 10)
	'((1 1) (1 2) (2 2) (1 3) (2 3) (3 3) (1 4) (2 4) (3 4) (1 5)))
(assert (stream-head (stream-map (weighted-pairs integers integers sum-of-cubes) sum-of-cubes) 10)
	'(2 9 16 28 35 54 65 72 91 126))
(assert (stream->list (stream-repeats (list->stream '(0 1 1 2 3 3 3))))
	'(1 3 3))
(assert (stream-head ramanujan-numbers 6)
	'(1729 4104 13832 20683 32832 39312))
