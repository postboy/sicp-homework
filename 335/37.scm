; Exercise 3.37.  The celsius-fahrenheit-converter procedure is cumbersome when compared with a more expression-oriented style of definition, such as <...>. Here c+, c*, etc. are the ``constraint'' versions of the arithmetic operations. For example, c+ takes two connectors as arguments and returns a connector that is related to these by an adder constraint: <...>. Define analogous procedures c-, c*, c/, and cv (constant value) that enable us to define compound constraints as in the converter example above.

(load "ch335_common.scm")

(define (c+ x y)
  (let ((z (make-connector)))
    (adder x y z)
    z))

(define (c- x y)
  (let ((z (make-connector)))
    (adder z y x)
    z))

(define (c* x y)
  (let ((z (make-connector)))
    (multiplier x y z)
    z))

(define (c/ x y)
  (let ((z (make-connector)))
    (multiplier z y x)
    z))

(define (cv x)
  (let ((z (make-connector)))
    (constant x z)
    z))

(define (celsius-fahrenheit-converter x)
  (c+ (c* (c/ (cv 9) (cv 5))
          x)
      (cv 32)))

(define C (make-connector))
(probe 'celsius C)
(define F (celsius-fahrenheit-converter C))
(probe 'fahrenheit F)
(assert (set! past-events nil) nil)

(set-value! C 25 'user)
(assert (set! past-events nil) '((celsius 25) (fahrenheit 77)))

(forget-value! C 'user)
(assert (set! past-events nil) '((celsius "?") (fahrenheit "?")))

(set-value! F 212 'user)
(assert (set! past-events nil) '((celsius 100) (fahrenheit 212)))

(define minuend (make-connector))
(probe 'minuend minuend)
(define subtrahend (make-connector))
(probe 'subtrahend subtrahend)
(define difference (c- minuend subtrahend))
(probe 'difference difference)
(assert (set! past-events nil) nil)

(set-value! minuend 25 'user)
(assert (set! past-events nil) '((minuend 25)))

(set-value! difference 15 'user)
(assert (set! past-events nil) '((subtrahend 10) (difference 15)))
