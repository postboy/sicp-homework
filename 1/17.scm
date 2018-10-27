; Exercise 1.17.  The exponentiation algorithms in this section are based on performing exponentiation by means of repeated multiplication. In a similar way, one can perform integer multiplication by means of repeated addition. The following multiplication procedure (in which it is assumed that our language can only add, not multiply) is analogous to the expt procedure:

(load "ch1_common.scm")

; this example shows that our language can also substract
(define (* a b)
  (if (= b 0)
      0
      (+ a (* a (- b 1)))))

; This algorithm takes a number of steps that is linear in b. Now suppose we include, together with addition, operations double, which doubles an integer, and halve, which divides an (even) integer by 2. Using these, design a multiplication procedure analogous to fast-expt that uses a logarithmic number of steps.

(define (double n)
  (* n 2))

(define (halve n)
  (/ n 2))

; does usage of this function still allowed?
(define (even? n)
  (= (remainder n 2) 0))

; analogous to * function, we use substaction
(define (fast-mul a b)
  (cond ((= b 0) 0)
        ((even? b) (fast-mul (double a) (halve b)))
        (else (+ a (fast-mul a (- b 1))))))

(define (test-mul f)
  (assert 0 (f 0 0))
  (assert 0 (f 0 1))
  (assert 0 (f 1 0))
  (assert 1 (f 1 1))
  (assert 2 (f 1 2))
  (assert 3 (f 1 3))
  (assert 0 (f 2 0))
  (assert 2 (f 2 1))
  (assert 4 (f 2 2))
  (assert 6 (f 2 3))
  (assert 0 (f 3 0))
  (assert 3 (f 3 1))
  (assert 6 (f 3 2))
  (assert 9 (f 3 3))
  (assert 12 (f 3 4))
  (assert 15 (f 3 5)))

(test-mul fast-mul)

; crosschecked: https://github.com/ivanjovanovic/sicp/blob/master/1.2/e-1.17.scm
; My solution is slightly better because it uses less memory.
