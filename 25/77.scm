; Exercise 2.77.  Louis Reasoner tries to evaluate the expression (magnitude z) where z is the object shown in figure 2.24. To his surprise, instead of the answer 5 he gets an error message from apply-generic, saying there is no method for the operation magnitude on the types (complex). He shows this interaction to Alyssa P. Hacker, who says ``The problem is that the complex-number selectors were never defined for complex numbers, just for polar and rectangular numbers. All you have to do to make this work is add the following to the complex package:''

(load "ch25_common.scm")

(put 'real-part '(complex) real-part)
(put 'imag-part '(complex) imag-part)
(put 'magnitude '(complex) magnitude)
(put 'angle '(complex) angle)

; Describe in detail why this works. As an example, trace through all the procedures called in evaluating the expression (magnitude z) where z is the object shown in figure 2.24. In particular, how many times is apply-generic invoked? What procedure is dispatched to in each case?

(define z (make-complex-from-real-imag 3 4))
(assert z '(complex rectangular 3 4))
(assert (magnitude z) 5)

; Complex numbers have two implementations, rectangular and polar, which are hidden under the abstraction barrier. "Complex number" level doesn't do anything by itself, it serves just as a wrapper for two implementations that contain all domain-specific logic. Alyssa's additions is a bit hacky, but totally correct. Her additions can be described as following: "If user asks to calculate some function with a complex number as an argument then remove "complex" tag and call this function again. Dispatcher will see implementation-specific tag and call implementation-specific function."

; (magnitude z)
; (magnitude '(complex rectangular 3 4))
; (apply-generic 'magnitude '((complex rectangular 3 4))) ; first call
; (apply (get 'magnitude '(complex)) '((rectangular 3 4)))
; (apply magnitude '((rectangular 3 4))) ; result of dispatching
; (magnitude '(rectangular 3 4))
; (apply-generic 'magnitude '((rectangular 3 4))) ; second call
; (apply (get 'magnitude '(rectangular)) '((3 4)))
; (apply magnitude-from-install-rectangular-package '((3 4))) ; result of dispatching
; (magnitude-from-install-rectangular-package '(3 4))
; (sqrt (+ (square (real-part '(3 4))) (square (imag-part '(3 4)))))
; (sqrt (+ (square (car '(3 4))) (square (cadr '(3 4)))))
; (sqrt (+ (square 3) (square 4)))
; (sqrt (+ 9 16))
; (sqrt 25)
; 5
