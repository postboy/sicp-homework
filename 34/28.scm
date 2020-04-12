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

(define the-agenda (make-agenda))
(define input-1 (make-wire))
(define input-2 (make-wire))
(define output (make-wire))

(probe 'output output)
; 0 * or-gate-delay
(assert (set! past-events nil) '((0 output 0)))

(or-gate input-1 input-2 output)
(propagate)
; 1 * or-gate-delay
(assert (set! past-events nil) nil)

(set-signal! input-1 1)
(propagate)
; 2 * or-gate-delay
(assert (set! past-events nil) '((10 output 1)))

(set-signal! input-2 1)
(propagate)
; 3 * or-gate-delay
(assert (set! past-events nil) nil)

(set-signal! input-1 0)
(propagate)
; 4 * or-gate-delay
(assert (set! past-events nil) nil)

(set-signal! input-2 0)
(propagate)
; 5 * or-gate-delay
(assert (set! past-events nil) '((25 output 0)))
