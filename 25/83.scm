; Exercise 2.83.  Suppose you are designing a generic arithmetic system for dealing with the tower of types shown in figure 2.25: integer, rational, real, complex. For each type (except complex), design a procedure that raises objects of that type one level in the tower. Show how to install a generic raise operation that will work for each type (except complex).

(load "ch25_common.scm")

(define (raise z) (apply-generic 'raise z))

(define (install-integer-package)
  ;; interface to rest of the system
  (define (tag x)
    (attach-tag 'integer x))
  (put 'make 'integer
       (lambda (x) (tag x)))
  ;; tower of types functions
  (put 'raise '(integer)
     (lambda (x) (make-rational x 1)))
  'done)

(define (make-integer n)
  ((get 'make 'integer) n))

(define (install-real-package)
  ;; internal procedures
  (define (make-real x)
    (+ x 0.0))
  ;; interface to rest of the system
  (define (tag x)
    (attach-tag 'real x))
  (put 'make 'real
       (lambda (x) (tag (make-real x))))
  ;; tower of types functions
  (put 'raise '(real)
       (lambda (x) (make-complex-from-real-imag x 0.0)))
  'done)

(define (make-real n)
  ((get 'make 'real) n))

(install-integer-package)
(install-real-package)

(define integer0 (make-integer 0))
(define real0 (make-real 0.0))
(define complex0-from-real (make-complex-from-real-imag 0.0 0.0))

(assert (raise integer0) rat0)
(assert (raise rat0) real0)
(assert (raise real0) complex0-from-real)
; this call produces an error
; (raise complex0-from-real)
