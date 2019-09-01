; Exercise 2.80.  Define a generic predicate =zero? that tests if its argument is zero, and install it in the generic arithmetic package. This operation should work for ordinary numbers, rational numbers, and complex numbers.

; Solution is there:
(load "ch25_common.scm")

(assert (=zero? sn0) #t)
(assert (=zero? sn1) #f)

(assert (=zero? rat0) #t)
(assert (=zero? rat1) #f)

(assert (=zero? comp00) #t)
(assert (=zero? comp01) #f)
(assert (=zero? comp10) #f)
