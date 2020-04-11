; Exercise 3.30.  Figure 3.27 shows a ripple-carry adder formed by stringing together n full-adders. This is the simplest form of parallel adder for adding two n-bit binary numbers. The inputs A1, A2, A3, ..., An and B1, B2, B3, ..., Bn are the two binary numbers to be added (each Ak and Bk is a 0 or a 1). The circuit generates S1, S2, S3, ..., Sn, the n bits of the sum, and C, the carry from the addition. Write a procedure ripple-carry-adder that generates this circuit. The procedure should take as arguments three lists of n wires each -- the Ak, the Bk, and the Sk -- and also another wire C. The major drawback of the ripple-carry adder is the need to wait for the carry signals to propagate. What is the delay needed to obtain the complete output from an n-bit ripple-carry adder, expressed in terms of the delays for and-gates, or-gates, and inverters?

(load "ch34_common.scm")

(define (ripple-carry-adder Ak Bk C-in Sk C-out)
  (if (null? (cdr Ak))
      (begin
	(full-adder (car Ak) (car Bk) C-in (car Sk) C-out)
	'ok)
      (let ((next-carry (make-wire)))
	(full-adder (car Ak) (car Bk) C-in (car Sk) next-carry)
	(ripple-carry-adder (cdr Ak) (cdr Bk) next-carry (cdr Sk) C-out))))

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

; tests here
