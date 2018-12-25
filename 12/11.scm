; Exercise 1.11.  A function f is defined by the rule that f(n) = n if n < 3 and f(n) = f(n-1) + 2f(n-2) + 3f(n-3) if n >= 3. Write a procedure that computes f by means of a recursive process. Write a procedure that computes f by means of an iterative process.

(load "ch12_common.scm")

(define (f1 n)
  (cond ((< n 3) n)
        (else (+ (f1 (- n 1))
                 (* 2 (f1 (- n 2)))
		 (* 3 (f1 (- n 3)))))))

(define (f2 n)
  (f-iter 2 1 0 n))

(define (f-iter a b c count)
  (cond ((< count 2) count)
	((= count 2) a)
	(else (f-iter (+ a
			 (* 2 b)
			 (* 3 c))
		      a
		      b
		      (- count 1)))))

(define (test-f f)
  (assert (f -1) -1)
  (assert (f 0) 0)
  (assert (f 1) 1)
  (assert (f 2) 2)
  (assert (f 3) 4)
  (assert (f 4) 11)
  (assert (f 5) 25))

(test-f f1)
(test-f f2)
