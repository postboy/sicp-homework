; Exercise 3.8.  When we defined the evaluation model in section 1.1.3, we said that the first step in evaluating an expression is to evaluate its subexpressions. But we never specified the order in which the subexpressions should be evaluated (e.g., left to right or right to left). When we introduce assignment, the order in which the arguments to a procedure are evaluated can make a difference to the result. Define a simple procedure f such that evaluating (+ (f 0) (f 1)) will return 0 if the arguments to + are evaluated from left to right but will return 1 if the arguments are evaluated from right to left.

(load "ch31_common.scm")

(define (make-f)
  (let ((ret-n #f))
    (lambda (n)
      (set! ret-n (not ret-n))
      (if ret-n
	  n
	  0))))
(define f (make-f))

; simplest way to check ourself:
; (trace f)
(assert (+ (f 0) (f 1)) 1)
(assert (+ (f 0) (f 1)) 1)
; what would have happened if order of evaluation was different?
(assert (+ (f 1) (f 0)) 0)
(assert (+ (f 1) (f 0)) 0)
; function still works right
(assert (+ (f 0) (f 1)) 1)
