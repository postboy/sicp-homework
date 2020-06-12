; Exercise 3.72.  In a similar way to exercise 3.71 generate a stream of all numbers that can be written as the sum of two squares in three different ways (showing how they can be so written).

(load "71.scm")

(define (sum-of-squares p)
  (+ (square (car p)) (square (cadr p))))

; initial streams
(define sorted-pairs (weighted-pairs integers integers sum-of-squares))
(define weights (stream-map sorted-pairs sum-of-squares))

(assert (stream-head sorted-pairs 15)
	'((1 1) (1 2) (2 2) (1 3) (2 3) (1 4) (3 3) (2 4) (3 4) (1 5) (2 5) (4 4) (3 5) (1 6) (2 6)))
(assert (stream-head weights 15)
	'(2 5 8 10 13 17 18 20 25 26 29 32 34 37 40))

(define repeats (stream-repeats weights))

(define naive-solution (numbers (stream-repeats (numbers repeats))))
(assert (stream-head naive-solution 5)
	'(325 425 650 725 845))

; indexes of repeats which are double repeats
(define indexes-in-repeats (indexes (stream-repeats (numbers repeats))))

(define (stream-by-indexes stream inds)
  (define (func i) (stream-ref stream i))
  (stream-map func inds))

(define indexes-in-initial-streams (indexes (stream-by-indexes repeats indexes-in-repeats)))

(define (internal-loop w p inds)
  (define (func i)
    (list (stream-ref w i)
	  (stream-ref p (+ i 0))
	  (stream-ref p (+ i 1))
	  (stream-ref p (+ i 2))))
  (stream-map func inds))

; if there is more than three ways then this stream will show this detail too (although in ugly way)
(define result-stream (internal-loop weights sorted-pairs indexes-in-initial-streams))

(assert (stream-head result-stream 5)
	'((325 (1 18) (6 17) (10 15))
	  (425 (5 20) (8 19) (13 16))
	  (650 (5 25) (11 23) (17 19))
	  (725 (7 26) (10 25) (14 23))
	  (845 (2 29) (13 26) (19 22))))
