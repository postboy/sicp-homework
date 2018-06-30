Exercise 1.16.  Design a procedure that evolves an iterative exponentiation process that uses successive squaring and uses a logarithmic number of steps, as does fast-expt. (Hint: Using the observation that (b^(n/2))^2 = (b^2)^(n/2), keep, along with the exponent n and the base b, an additional state variable a, and define the state transformation in such a way that the product a*b^n is unchanged from state to state. At the beginning of the process a is taken to be 1, and the answer is given by the value of a at the end of the process. In general, the technique of defining an invariant quantity that remains unchanged from state to state is a powerful way to think about the design of iterative algorithms.)

(define (even? n)
  (= (remainder n 2) 0))

(define (my-expt-iter b n a)
  (cond ((= n 0) a)
	((= n 2) (my-expt-iter b 0 (* (square b) a)))
	((even? n) (my-expt-iter b (/ n 2) (* (square b) a)))
	(else (my-expt-iter b (- n 1) (* b a)))))

(define (my-expt b n)
  (my-expt-iter b n 1))

(my-expt 1 0) ; 1
(my-expt 1 1) ; 1
(my-expt 1 2) ; 1
(my-expt 2 0) ; 1
(my-expt 2 1) ; 2
(my-expt 2 2) ; 4
(my-expt 2 3) ; 8
(my-expt 2 4) ; 16
(my-expt 2 5) ; 32
(my-expt 3 0) ; 1
(my-expt 3 1) ; 3
(my-expt 3 2) ; 9
(my-expt 3 3) ; 27
(my-expt 3 4) ; 81
(my-expt 3 5) ; 243
