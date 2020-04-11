; Exercise 3.28.  Define an or-gate as a primitive function box. Your or-gate constructor should be similar to and-gate.

(load "ch34_common.scm")

(define or-gate-delay 5)

(define (logical-or a1 a2)
  (cond ((and (= a1 0) (= a2 0)) 0)
	((and (= a1 0) (= a2 1)) 1)
	((and (= a1 1) (= a2 0)) 1)
	((and (= a1 1) (= a2 1)) 1)
	(else (error "Invalid signal(s)" a1 a2))))

(define (or-gate a1 a2 output)
  (define (or-action-procedure)
    (let ((new-value
           (logical-or (get-signal a1) (get-signal a2))))
      (after-delay or-gate-delay
                   (lambda ()
                     (set-signal! output new-value)))))
  (add-action! a1 or-action-procedure)
  (add-action! a2 or-action-procedure)
  'ok)

; tests here
