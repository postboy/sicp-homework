; Exercise 3.31.   The internal procedure accept-action-procedure! defined in make-wire specifies that when a new action procedure is added to a wire, the procedure is immediately run. Explain why this initialization is necessary. In particular, trace through the half-adder example in the paragraphs above and say how the system's response would differ if we had defined accept-action-procedure! as <...>

(load "28.scm")

;(define (accept-action-procedure! proc)
;  (set! action-procedures (cons proc action-procedures)))

(define the-agenda (make-agenda))
(define input-1 (make-wire))
(define input-2 (make-wire))
(define sum (make-wire))
(define carry (make-wire))
(probe 'sum sum)
; sum 0  New-value = 0
(probe 'carry carry)
; carry 0  New-value = 0
(half-adder input-1 input-2 sum carry)
(set-signal! input-1 1)
(propagate)
; sum 8  New-value = 1
(set-signal! input-2 1)
(propagate)
; carry 11  New-value = 1
; sum 16  New-value = 0
