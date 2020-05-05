; Exercise 3.51.  In order to take a closer look at delayed evaluation, we will use the following procedure, which simply returns its argument after printing it: <...> What does the interpreter print in response to evaluating each expression in the following sequence?

(load "ch35_common.scm")

; this reversed list will contain lines that interpreter would otherwise printed
(define lines-to-show nil)
(define (show x)
  (set! lines-to-show (cons x lines-to-show))
  x)

(define x (stream-map show (stream-enumerate-interval 0 10)))
(assert (set! lines-to-show nil) '(0))

(assert (stream-ref x 5) 5)
(assert (set! lines-to-show nil) '(5 4 3 2 1))

(assert (stream-ref x 7) 7)
(assert (set! lines-to-show nil) '(7 6))
