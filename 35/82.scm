; Exercise 3.82.  Redo exercise 3.5 on Monte Carlo integration in terms of streams. The stream version of estimate-integral will not have an argument telling how many trials to perform. Instead, it will produce a stream of estimates based on successively more trials.

(cd "../31")
(load "5.scm")
(cd "../35")
(load "ch35_common.scm")

(define (random-numbers-in-range low high)
  (define range (- high low))
  (cons-stream (+ low (random range))
	       (random-numbers-in-range low high)))

(stream-head (random-numbers-in-range -1 1) 5)
(stream-head (random-numbers-in-range -1.0 1.0) 5)

(define (monte-carlo experiments)
  (define (iter passed overall exps)
    (define new-overall (inc overall))
    (define new-passed
      (if (and (not (stream-null? exps)) (stream-car exps))
	  (inc passed)
	  passed))
    (if (stream-null? exps)
	the-empty-stream
	(cons-stream (/ (+ 0.0 new-passed) new-overall)
		     (iter new-passed new-overall (stream-cdr exps)))))
  (iter 0 0 experiments))

(assert (stream->list (monte-carlo (list->stream '(#f #t #f #t #f #t))))
	'(0. .5 .3333333333333333 .5 .4 .5))

(define (estimate-integral P x1 x2 y1 y2)
  (define rand-xs (random-numbers-in-range x1 x2))
  (define rand-ys (random-numbers-in-range y1 y2))
  (define experiments (stream-map P rand-xs rand-ys))
  (define rect-square (* (- x2 x1) (- y2 y1)))
  (scale-stream (monte-carlo experiments) rect-square))

(assert (stream-ref (estimate-integral always-true -1 2 -2 3) 10) 15.)
(assert (stream-ref (estimate-integral always-false -1 2 -2 3) 10) 0.)
; pi ~ 3.1416
(stream-ref (estimate-integral in-unit-circle? -1.0 1.0 -1.0 1.0) 100000)
