; Exercise 2.6.  In case representing pairs as procedures wasn't mind-boggling enough, consider that, in a language that can manipulate procedures, we can get by without numbers (at least insofar as nonnegative integers are concerned) by implementing 0 and the operation of adding 1 as <...>. This representation is known as Church numerals, after its inventor, Alonzo Church, the logician who invented the  calculus.
; Define one and two directly (not in terms of zero and add-1). (Hint: Use substitution to evaluate (add-1 zero)). Give a direct definition of the addition procedure + (not in terms of repeated application of add-1).

(load "../12/ch12_common.scm")

(define (add-1 n)
  (lambda (f) (lambda (x) (f ((n f) x)))))

(define zero (lambda (f) (lambda (x) x)))

; (add-1 zero)
; (add-1 (lambda (f) (lambda (x) x)))
; (lambda (f) (lambda (x) (f  ( ((lambda (f) (lambda (x) x)) f)  x) )))
; (lambda (f) (lambda (x) (f  ((lambda (x) x) x) )))
; (lambda (f) (lambda (x) (f  x )))

(define one (lambda (f) (lambda (x) (f x))))

; (add-1 one)
; (add-1 (lambda (f) (lambda (x) (f x))))
; (lambda (f) (lambda (x) (f  ( ((lambda (f) (lambda (x) (f x))) f)  x) )))
; (lambda (f) (lambda (x) (f  ( (lambda (x) (f x))  x) )))
; (lambda (f) (lambda (x) (f  (f x) )))

(define two (lambda (f) (lambda (x) (f (f x)))))

(define (add-church-nums a b)
  (lambda (f) (lambda (x) ((a f) ((b f) x)))))

; for testing
(define real-zero 0)
(define real-add-1 (lambda (x) (+ x 1)))

(assert ((zero real-add-1) real-zero) 0)
(assert ((one real-add-1) real-zero) 1)
(assert ((two real-add-1) real-zero) 2)

(assert (((add-church-nums zero two) real-add-1) real-zero) 2)
(assert (((add-church-nums one one) real-add-1) real-zero) 2)
