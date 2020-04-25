; Exercise 3.34.  Louis Reasoner wants to build a squarer, a constraint device with two terminals such that the value of connector b on the second terminal will always be the square of the value a on the first terminal. He proposes the following simple device made from a multiplier: <...>. There is a serious flaw in this idea. Explain.

(load "ch335_common.scm")

(define (squarer a b)
  (multiplier a a b))

(define root (make-connector))
(probe 'root root)
(define square (make-connector))
(probe 'square square)

(squarer root square)
(assert (set! past-events nil) nil)

; This implementation is hilarious. It works in one direction:
(set-value! root 10 'user)
(assert (set! past-events nil) '((root 10) (square 100)))

(forget-value! root 'user)
(assert (set! past-events nil) '((root "?") (square "?")))

; But not in another:
(set-value! square 100 'user)
(assert (set! past-events nil) '((square 100)))

; The reason is interesting: multiplier doesn't know that first and second inputs are connected to the same connector and must have the same value. If squarer gets a then multiplier gets a and b, so it can compute c. If squarer gets b then multiplier gets c, so it can't compute a and b: multiplier is programmed to compute one value from the other two values.
