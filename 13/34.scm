; Exercise 1.34.  Suppose we define the procedure

(load "ch13_common.scm")

(define (f g)
  (g 2))

; Then we have

(assert 4 (f square))

(assert 6 (f (lambda (z) (* z (+ z 1)))))

; What happens if we (perversely) ask the interpreter to evaluate the combination (f f)? Explain.

(f f)

; We've got an error "The object 2 is not applicable". Let's use substitution model to find out why it happened.
; That's easy: (f f) -> (f 2) -> (2 2). Last expression is ill-formed because 2 is an integer, not a function, but is located in position for a function.
