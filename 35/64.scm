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

(define (stream-limit s tolerance)
  (define (stream-limit-internal prev rest)
    (if (stream-null? rest)
      (error "stream ended before required criterion was met")
    (let ((cur (stream-car rest)))
      (if (< (abs (- cur prev)) tolerance)
	  cur
	  (stream-limit-internal cur (stream-cdr rest))))))
  (if (stream-null? s)
      (error "stream is empty")
      (stream-limit-internal (stream-car s) (stream-cdr s))))

(assert (sqrt 2 0.0001) 1.4142135623746899)

; this calls produce error messages
; (stream-limit the-empty-stream 1)
; (stream-limit (cons-stream 1 the-empty-stream) 1)
