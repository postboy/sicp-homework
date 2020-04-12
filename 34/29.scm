; Exercise 3.29.  Another way to construct an or-gate is as a compound digital logic device, built from and-gates and inverters. Define a procedure or-gate that accomplishes this. What is the delay time of the or-gate in terms of and-gate-delay and inverter-delay?

(load "ch34_common.scm")

(define (or-gate a1 a2 output)
  (let ((a1i (make-wire)) (a2i (make-wire)) (resi (make-wire)))
    (inverter a1 a1i)
    (inverter a2 a2i)
    (and-gate a1i a2i resi)
    (inverter resi output)
    'ok))

; first and second inverters work in parallel, then and-gate, then inverter
(define or-delay-max (+ inverter-delay and-gate-delay inverter-delay))
; first and second inverters work in parallel, then and-gate that don't change its output
(define or-delay-min (+ inverter-delay and-gate-delay))

(define the-agenda (make-agenda))
(define input-1 (make-wire))
(define input-2 (make-wire))
(define output (make-wire))

(probe 'output output)
(assert (current-time the-agenda) 0)
(assert (set! past-events nil) '((0 output 0)))

(or-gate input-1 input-2 output)
(propagate)
(assert (current-time the-agenda) (* or-delay-max 1))
(assert (set! past-events nil) '((7 output 0) (2 output 1)))

(set-signal! input-1 1)
(propagate)
(assert (current-time the-agenda) (* or-delay-max 2))
(assert (set! past-events nil) '((14 output 1)))

(set-signal! input-2 1)
(propagate)
(assert (current-time the-agenda) (+ (* or-delay-max 2) (* or-delay-min 1)))
(assert (set! past-events nil) nil)

(set-signal! input-1 0)
(propagate)
(assert (current-time the-agenda) (+ (* or-delay-max 2) (* or-delay-min 2)))
(assert (set! past-events nil) nil)

(set-signal! input-2 0)
(propagate)
(assert (current-time the-agenda) (+ (* or-delay-max 3) (* or-delay-min 2)))
(assert (set! past-events nil) '((31 output 0)))
