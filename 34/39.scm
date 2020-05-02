; Exercise 3.39.  Which of the five possibilities in the parallel execution shown above remain if we instead serialize execution as follows:

(load "ch34_common.scm")

(define x 10)
(define s (make-serializer))
(allow-preempt-current-thread)
(parallel-execute (lambda () (set! x ((s (lambda () (* x x))))))
                  (s (lambda () (set! x (+ x 1)))))
; Unfortunately, I always get 101 here.
; (display x)

; Here we have three distinct fragments:
; A: (s (lambda () (set! x (+ x 1))))
; B: (s (lambda () (* x x)))
; C: (set! x 2nd-action-result).

; A and B are protected by same serializer, so their execution cannot interleave with each other. However, they can execute in any order, be it AB or BA.
; C has B's result as a prerequisite for execution, so order of their execution is BC.
; A and C can interleave with each other and can execute in any order.

; Possible results of execution is:
; 101: A sets x to 100 and then BC increments x to 101. 
; 121: BC increments x to 11 and then A sets x to x times x.
; 100: B accesses x (twice), then A sets x to 11, then C sets x.

; Results that are no longer possible thanks to serializer:
; 110: A changes x from 10 to 11 between the two times that B accesses the value of x during the evaluation of (* x x).
; 11:  A accesses x, then BC sets x to 100, then A sets x.
