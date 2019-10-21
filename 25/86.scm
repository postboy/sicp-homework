; Exercise 2.86.  Suppose we want to handle complex numbers whose real parts, imaginary parts, magnitudes, and angles can be either ordinary numbers, rational numbers, or other numbers we might wish to add to the system. Describe and implement the changes to the system needed to accommodate this. You will have to define operations such as sine and cosine that are generic over ordinary numbers and rational numbers.

; We should implement most of operations in complex and rectangular packages as recursive. Such operations shouldn't be implemented like this:
; (define (add-complex z1 z2)
;   (make-from-real-imag (+ (real-part z1) (real-part z2))
;		         (+ (imag-part z1) (imag-part z2))))
; (put 'add '(complex complex)
;      (lambda (z1 z2) (tag (add-complex z1 z2))))

; This implementation assumes that real-part and imag-part will return Scheme numbers which we can add with "+". This is no longer true: they can be either ordinary numbers, rational numbers, or other numbers we might wish to add to the system. From now on, here we should use generic operation "add" instead of "+". This may seem strange at first, but we indeed should use generic operation "add" inside "add" implementation for a particular data type. This won't give us an infinite recursion because on each step we do simplify an initial problem by converting it to set of smaller problems.

; We also should implement generic operations squar, sqroot, sine, cosine, arctan in scheme-number and rational packages. Potentially we could implement them only for rational numbers and process Scheme numbers by raising them to rational ones (see 2.83), but I don't want to cause confusion due to two different towers of types in code.
