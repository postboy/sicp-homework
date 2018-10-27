; Exercise 1.17.  The exponentiation algorithms in this section are based on performing exponentiation by means of repeated multiplication. In a similar way, one can perform integer multiplication by means of repeated addition. The following multiplication procedure (in which it is assumed that our language can only add, not multiply) is analogous to the expt procedure:

(load "ch1_common.scm")

(define (* a b)
  (if (= b 0)
      0
      (+ a (* a (- b 1)))))

; This algorithm takes a number of steps that is linear in b. Now suppose we include, together with addition, operations double, which doubles an integer, and halve, which divides an (even) integer by 2. Using these, design a multiplication procedure analogous to fast-expt that uses a logarithmic number of steps.

(define (double n)
  (* n 2))

(define (halve n)
  (/ n 2))

(define (even? n)
  (= (remainder n 2) 0))

(define (fast-mul a b)
  (cond ((= b 0) 0)
        ((even? b) (double (fast-mul a (halve b))))
        (else (+ a (fast-mul a (- b 1))))))

(assert 0 (fast-mul 0 0))
(assert 0 (fast-mul 0 1))
(assert 0 (fast-mul 1 0))
(assert 1 (fast-mul 1 1))
(assert 2 (fast-mul 1 2))
(assert 3 (fast-mul 1 3))
(assert 0 (fast-mul 2 0))
(assert 2 (fast-mul 2 1))
(assert 4 (fast-mul 2 2))
(assert 6 (fast-mul 2 3))
(assert 0 (fast-mul 3 0))
(assert 3 (fast-mul 3 1))
(assert 6 (fast-mul 3 2))
(assert 9 (fast-mul 3 3))
(assert 12 (fast-mul 3 4))
(assert 15 (fast-mul 3 5))
