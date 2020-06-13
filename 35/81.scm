; Exercise 3.81.  Exercise 3.6 discussed generalizing the random-number generator to allow one to reset the random-number sequence so as to produce repeatable sequences of ``random'' numbers. Produce a stream formulation of this same generator that operates on an input stream of requests to generate a new random number or to reset the sequence to a specified value and that produces the desired stream of random numbers. Don't use assignment in your solution.

(load "ch35_common.scm")

(define (make-rand requests seed)
  (define (rand-update x) (inc x))
  (define (dispatch msg prev)
    (cond ((and (pair? msg) (eq? (car msg) 'reset)) (cadr msg))
	  ((eq? msg 'generate) (rand-update prev))
	  (else (error "Unknown request -- MAKE-RAND" msg))))
  (define numbers (cons-stream seed
			       (stream-map dispatch requests numbers)))
  numbers)

(define requests (list->stream '(generate generate generate (reset 2) generate generate)))
(assert (stream->list (make-rand requests 2)) '(2 3 4 5 2 3 4))
