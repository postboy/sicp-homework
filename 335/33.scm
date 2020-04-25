; Exercise 3.33.  Using primitive multiplier, adder, and constant constraints, define a procedure averager that takes three connectors a, b, and c as inputs and establishes the constraint that the value of c is the average of the values of a and b.

(load "ch335_common.scm")

(define (averager a b c)
  (let ((a-m (make-connector))
        (half (make-connector)))
    (adder a b a-m)
    (multiplier a-m half c)
    (constant 0.5 half)
    'ok))

(define first (make-connector))
(probe 'first first)
(define second (make-connector))
(probe 'second second)
(define average (make-connector))
(probe 'average average)

(averager first second average)
(assert (set! past-events nil) nil)

(set-value! first 10 'user)
(assert (set! past-events nil) '((first 10)))

(set-value! second 20 'user)
(assert (set! past-events nil) '((second 20) (average 15.)))

(forget-value! second 'user)
(assert (set! past-events nil) '((second "?") (average "?")))

(set-value! average 15 'user)
(assert (set! past-events nil) '((average 15) (second 20.)))

(set-value! second 20 'user)
(assert (set! past-events nil) nil)
