; Exercise 3.29.  Another way to construct an or-gate is as a compound digital logic device, built from and-gates and inverters. Define a procedure or-gate that accomplishes this. What is the delay time of the or-gate in terms of and-gate-delay and inverter-delay?

(load "ch34_common.scm")

(define (or-gate a1 a2 output)
  (let ((a1i (make-wire)) (a2i (make-wire)) (resi (make-wire)))
    (inverter a1 a1i)
    (inverter a2 a2i)
    (and-gate a1i a2i resi)
    (inverter resi output)
    'ok))

; or-delay = inv-delay (first and second inverters work in parallel) + and-delay + inv-delay

; tests here
