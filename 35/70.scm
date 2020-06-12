; Exercise 3.70.  It would be nice to be able to generate streams in which the pairs appear in some useful order, rather than in the order that results from an ad hoc interleaving process. We can use a technique similar to the merge procedure of exercise 3.56, if we define a way to say that one pair of integers is ``less than'' another. One way to do this is to define a ``weighting function'' W(i,j) and stipulate that (i1,j1) is less than (i2,j2) if W(i1,j1) =< W(i2,j2). Write a procedure merge-weighted that is like merge, except that merge-weighted takes an additional argument weight, which is a procedure that computes the weight of a pair, and is used to determine the order in which elements should appear in the resulting merged stream. Using this, generalize pairs to a procedure weighted-pairs that takes two streams, together with a procedure that computes a weighting function, and generates the stream of pairs, ordered according to weight. Use your procedure to generate

(load "ch35_common.scm")

(define (merge-weighted s1 s2 weight)
  (cond ((stream-null? s1) s2)
        ((stream-null? s2) s1)
        (else
         (let ((s1car (stream-car s1))
               (s2car (stream-car s2)))
	   (cond ((> (weight s1car) (weight s2car))
		  (cons-stream s2car (merge-weighted s1 (stream-cdr s2) weight)))
		 (else
		  ; order of streams is insignificant so let's interleave them
		  (cons-stream s1car (merge-weighted s2 (stream-cdr s1) weight))))))))

(assert (stream->list
	 (merge-weighted (list->stream '(1 2 3)) (list->stream '(1 1 4)) identity))
	'(1 1 1 2 3 4))

(define (weighted-pairs s t weight)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (merge-weighted
    (stream-map (lambda (x) (list (stream-car s) x))
                (stream-cdr t))
    (weighted-pairs (stream-cdr s) (stream-cdr t) weight)
    weight)))

; a. the stream of all pairs of positive integers (i,j) with i =< j ordered according to the sum i + j

(define (sum-of-pair p) (+ (car p) (cadr p)))

(assert (stream-head (weighted-pairs integers integers sum-of-pair) 10)
	'((1 1) (1 2) (2 2) (1 3) (2 3) (1 4) (3 3) (1 5) (2 4) (1 6)))

; b. the stream of all pairs of positive integers (i,j) with i =< j, where neither i nor j is divisible by 2, 3, or 5, and the pairs are ordered according to the sum 2*i + 3*j + 5*i*j.

(define (complex-sum-of-pair p) (+ (* 2 (car p)) (* 3 (cadr p)) (* 5 (car p) (cadr p))))
(define (not-divisable-filter x) (not (or (divides? 2 x) (divides? 3 x) (divides? 5 x))))
(define not-divisable-integers (stream-filter not-divisable-filter integers))

(assert (stream-head (weighted-pairs not-divisable-integers not-divisable-integers complex-sum-of-pair) 10)
	'((1 1) (1 7) (1 11) (1 13) (1 17) (1 19) (1 23) (1 29) (1 31) (7 7)))
