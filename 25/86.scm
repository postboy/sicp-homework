; Exercise 2.86.  Suppose we want to handle complex numbers whose real parts, imaginary parts, magnitudes, and angles can be either ordinary numbers, rational numbers, or other numbers we might wish to add to the system. Describe and implement the changes to the system needed to accommodate this. You will have to define operations such as sine and cosine that are generic over ordinary numbers and rational numbers.

(load "82.scm")

; We should implement most of operations in complex and rectangular packages as recursive. Such operations shouldn't be implemented like this:
; (define (add-complex z1 z2)
;   (make-from-real-imag (+ (real-part z1) (real-part z2))
;		         (+ (imag-part z1) (imag-part z2))))
; (put 'add '(complex complex)
;      (lambda (z1 z2) (tag (add-complex z1 z2))))

; This implementation assumes that real-part and imag-part will return Scheme numbers which we can add with "+". This is no longer true: they can be either ordinary numbers, rational numbers, or other numbers we might wish to add to the system. From now on, here we should use generic operation "add" instead of "+". This may seem strange at first, but we indeed should use generic operation "add" inside "add" implementation for a particular data type. This won't give us an infinite recursion because on each step we do simplify an initial problem by converting it to set of smaller problems.

; We also should implement generic operations squar, sqroot, sine, cosine, arctan in scheme-number and rational packages. Potentially we could implement them only for rational numbers and process Scheme numbers by raising them to rational ones (see 2.83), but I don't want to cause confusion due to two different towers of types in code.

; Most of the solution is located in ch25_common.scm.

; As the following tests show, simplification of operations' results (see 2.85) could be useful in our system.

(define comp-ma-0 (make-complex-from-mag-ang rat0 rat0))
(define comp-ma-0-mixed1 (make-complex-from-mag-ang rat0 sn0))
(define comp-ma-0-mixed2 (make-complex-from-mag-ang sn0 rat0))
(define comp-ri-1 (make-complex-from-real-imag rat05 rat1))
(define comp-ri-1-mixed (make-complex-from-real-imag rat05 sn1))

(assert (add comp-ri-1 comp-ma-0) comp-ri-1)
(assert (add comp-ri-1-mixed comp-ma-0-mixed1) comp-ri-1)
(assert (add comp-ma-0-mixed2 comp-ri-1-mixed) comp-ri-1-mixed)

(assert (sub comp-ri-1 comp-ma-0) comp-ri-1)
(assert (sub comp-ri-1-mixed comp-ma-0-mixed1) comp-ri-1)
(assert (sub comp-ri-1-mixed comp-ma-0-mixed2) comp-ri-1-mixed)

(assert (mul comp-ri-1 comp-ma-0) comp-ma-0-mixed2)
(assert (mul comp-ri-1-mixed comp-ma-0-mixed1) comp-ma-0-mixed2)
(assert (mul comp-ma-0-mixed2 comp-ri-1-mixed) comp-ma-0-mixed2)

(assert (div comp-ma-0 comp-ri-1) comp-ma-0-mixed2)
(assert (div comp-ma-0-mixed1 comp-ri-1-mixed) comp-ma-0-mixed2)
(assert (div comp-ma-0-mixed2 comp-ri-1-mixed) comp-ma-0-mixed2)
