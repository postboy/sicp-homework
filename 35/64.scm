; Exercise 3.64.  Write a procedure stream-limit that takes as arguments a stream and a number (the tolerance). It should examine the stream until it finds two successive elements that differ in absolute value by less than the tolerance, and return the second of the two elements. Using this, we could compute square roots up to a given tolerance by

(load "ch35_common.scm")

(define (sqrt x tolerance)
  (stream-limit (sqrt-stream x) tolerance))

(define (sqrt-improve guess x)
  (average guess (/ x guess)))

(define (sqrt-stream x)
  (define guesses
    (cons-stream 1.0
                 (stream-map (lambda (guess)
                               (sqrt-improve guess x))
                             guesses)))
  guesses)

(define (stream-limit-w-iters s tolerance)
  (define (internal prev rest i)
    (if (stream-null? rest)
      (error "stream ended before required criterion was met")
      (let ((cur (stream-car rest))
	    (cur-num (+ i 1)))
	(if (< (abs (- cur prev)) tolerance)
	    (list cur cur-num)
	    (internal cur (stream-cdr rest) cur-num)))))
  (if (stream-null? s)
      (error "stream is empty")
      (internal (stream-car s) (stream-cdr s) 1)))

(define (stream-limit s tolerance)
  (car (stream-limit-w-iters s tolerance)))
(define (stream-iters s tolerance)
  (cadr (stream-limit-w-iters s tolerance)))

(assert (sqrt 2 0.0001) 1.4142135623746899)

; this calls produce error messages
; (stream-limit the-empty-stream 1)
; (stream-limit (cons-stream 1 the-empty-stream) 1)
