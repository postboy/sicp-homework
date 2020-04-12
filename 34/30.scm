; Exercise 3.30.  Figure 3.27 shows a ripple-carry adder formed by stringing together n full-adders. This is the simplest form of parallel adder for adding two n-bit binary numbers. The inputs A1, A2, A3, ..., An and B1, B2, B3, ..., Bn are the two binary numbers to be added (each Ak and Bk is a 0 or a 1). The circuit generates S1, S2, S3, ..., Sn, the n bits of the sum, and C, the carry from the addition. Write a procedure ripple-carry-adder that generates this circuit. The procedure should take as arguments three lists of n wires each -- the Ak, the Bk, and the Sk -- and also another wire C. The major drawback of the ripple-carry adder is the need to wait for the carry signals to propagate. What is the delay needed to obtain the complete output from an n-bit ripple-carry adder, expressed in terms of the delays for and-gates, or-gates, and inverters?

(load "28.scm")

(define (ripple-carry-adder Ak Bk C-in Sk C-out)
  (if (null? (cdr Ak))
      (begin
	(full-adder (car Ak) (car Bk) C-in (car Sk) C-out)
	'ok)
      (let ((next-carry (make-wire)))
	(full-adder (car Ak) (car Bk) C-in (car Sk) next-carry)
	(ripple-carry-adder (cdr Ak) (cdr Bk) next-carry (cdr Sk) C-out))))

; Here for simplicity I pessimistically calculate the upper bounds of possible delays. During the simulation we can get smaller delays because some signal changes can stop propagating at some points, as we've seen in 3.29. Complexity of such calculations is one of the reasons why simulation of digital circuits is so important.

; Half-adder delays:
; ha-S-delay = (max or-delay (and-delay + inv-delay)) + and-delay
; ha-C-delay = and-delay

; Full-adder delays:
; fa-S-delay = ha-S-delay + ha-S-delay
; fa-C-delay = ha-S-delay + ha-C-delay + or-delay

; n-bit ripple-carry adder delays:
; rca-Sk-delay = (k-1) * fa-C-delay + fa-S-delay
; rca-C-delay = n * fa-C-delay
; rca-delay = (n-1) * fa-C-delay + (max fa-C-delay fa-S-delay)

(define the-agenda (make-agenda))
(define a1 (make-wire))
(define a2 (make-wire))
(define b1 (make-wire))
(define b2 (make-wire))
(define c-in (make-wire))
(define s1 (make-wire))
(define s2 (make-wire))
(define c-out (make-wire))

(probe 's1 s1)
(probe 's2 s2)
(probe 'c-out c-out)
(assert (current-time the-agenda) 0)
(assert (set! past-events nil) '((0 c-out 0) (0 s2 0) (0 s1 0)))

(ripple-carry-adder (list a1 a2) (list b1 b2) c-in (list s1 s2) c-out)
(propagate)
; Ripple-carry adder consists of full-adders. Each full-adder consists of half-adders. Each half-adder has inverter connected to and-gate. Inverter converts 0 to 1, but and-gate don't change its output. This process takes place in parallel in each half-adder inside the ripple-carry adder.
(assert (current-time the-agenda) (+ inverter-delay and-gate-delay))
(assert (set! past-events nil) nil)

(set-signal! a1 1)
(set-signal! a2 1)
(set-signal! b1 1)
(set-signal! b2 1)
(set-signal! c-in 1)
(propagate)
(assert (current-time the-agenda) 29)
(assert (set! past-events nil) '((29 s2 1) (21 s1 1) (21 s2 0) (21 s1 0) (21 c-out 1) (13 s2 1) (13 s1 1)))

(set-signal! b1 0)
(set-signal! b2 0)
(propagate)
(assert (current-time the-agenda) 61)
(assert (set! past-events nil) '((61 s2 0) (61 c-out 1) (53 s2 1) (53 c-out 0) (45 s2 0) (45 s1 0) (45 c-out 1) (37 c-out 0)))
