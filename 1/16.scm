; Exercise 1.16.  Design a procedure that evolves an iterative exponentiation process that uses successive squaring and uses a logarithmic number of steps, as does fast-expt. (Hint: Using the observation that (b^(n/2))^2 = (b^2)^(n/2), keep, along with the exponent n and the base b, an additional state variable a, and define the state transformation in such a way that the product a*b^n is unchanged from state to state. At the beginning of the process a is taken to be 1, and the answer is given by the value of a at the end of the process. In general, the technique of defining an invariant quantity that remains unchanged from state to state is a powerful way to think about the design of iterative algorithms.)

(load "ch1_common.scm")

(define (even? n)
  (= (remainder n 2) 0))

(define (my-expt-iter b n a)
  (cond ((= n 0) a)
	((even? n) (my-expt-iter (square b) (/ n 2) a))
	(else (my-expt-iter b (- n 1) (* b a)))))

(define (my-expt b n)
  (my-expt-iter b n 1))

(assert 1 (my-expt 1 0))
(assert 1 (my-expt 1 1))
(assert 1 (my-expt 1 2))
(assert 1 (my-expt 2 0))
(assert 2 (my-expt 2 1))
(assert 4 (my-expt 2 2))
(assert 8 (my-expt 2 3))
(assert 16 (my-expt 2 4))
(assert 32 (my-expt 2 5))
(assert 1 (my-expt 3 0))
(assert 3 (my-expt 3 1))
(assert 9 (my-expt 3 2))
(assert 27 (my-expt 3 3))
(assert 81 (my-expt 3 4))
(assert 243 (my-expt 3 5))

; crosschecked: https://github.com/ivanjovanovic/sicp/blob/master/1.2/e-1.16.scm
