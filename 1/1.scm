; Exercise 1.1.  Below is a sequence of expressions. What is the result printed by the interpreter in response to each expression? Assume that the sequence is to be evaluated in the order in which it is presented.

(define (assert exp act)
  (cond ((eq? exp act)
	 #t)
	(else
	 (display "assert failed!"))))

(assert 10 10)

(assert 12 (+ 5 3 4))

(assert 8 (- 9 1))

(assert 3 (/ 6 2))

(assert 6 (+ (* 2 4) (- 4 6)))

; assert don't work here
(define a 3) ; a

(define b (+ a 1)) ; b

(assert 19
	(+ a b
	      (* a b)))

(assert #f (= a b))

(assert 4
	(if (and (> b a) (< b (* a b)))
	    b
	    a))

(assert 16
	(cond ((= a 4) 6)
	      ((= b 4) (+ 6 7 a))
	      (else 25)))

(assert 6
	(+ 2
	   (if (> b a) b a)))

(assert 16
	(* (cond ((> a b) a)
		 ((< a b) b)
		 (else -1))
	   (+ a 1)))
