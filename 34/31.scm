; Exercise 3.31.   The internal procedure accept-action-procedure! defined in make-wire specifies that when a new action procedure is added to a wire, the procedure is immediately run. Explain why this initialization is necessary. In particular, trace through the half-adder example in the paragraphs above and say how the system's response would differ if we had defined accept-action-procedure! as <...>

(load "28.scm")

; normally uninitialized inverter works like this:

(define the-agenda (make-agenda))
(define input (make-wire))
(define output (make-wire))

(probe 'output output)
(assert (current-time the-agenda) 0)
(assert (set! past-events nil) '((0 output 0)))

(inverter input output)
(propagate)
(assert (current-time the-agenda) inverter-delay)
(assert (set! past-events nil) '((2 output 1)))

; let's redefine accept-action-procedure! (i.e. let's redefine make-wire) and see how inverter will work:

(define (make-wire)
  (let ((signal-value 0) (action-procedures '()))
    (define (set-my-signal! new-value)
      (if (not (= signal-value new-value))
          (begin (set! signal-value new-value)
                 (call-each action-procedures))
          'done))
    (define (accept-action-procedure! proc)
      (set! action-procedures (cons proc action-procedures)))
    (define (dispatch m)
      (cond ((eq? m 'get-signal) signal-value)
            ((eq? m 'set-signal!) set-my-signal!)
            ((eq? m 'add-action!) accept-action-procedure!)
            (else (error "Unknown operation -- WIRE" m))))
    dispatch))

(define the-agenda (make-agenda))
(define input (make-wire))
(define output (make-wire))

; this is OK
(probe 'output output)
(assert (current-time the-agenda) 0)
(assert (set! past-events nil) nil)

; this is wrong
(inverter input output)
(propagate)
(assert (current-time the-agenda) 0)
(assert (set! past-events nil) nil)
(assert (get-signal output) 0)

; Immediate launching of new action procedure is required for proper initialization of element outputs. New connections should be treated as events that trigger signal propagation even if the input values didn't changed.

; half-adder contains inverter as a component, so it generally won't work as expected too:

(define the-agenda (make-agenda))
(define input-1 (make-wire))
(define input-2 (make-wire))
(define sum (make-wire))
(define carry (make-wire))

; this is OK
(probe 'sum sum)
(probe 'carry carry)
(assert (current-time the-agenda) 0)
(assert (set! past-events nil) nil)

; this is OK
(half-adder input-1 input-2 sum carry)
(propagate)
(assert (current-time the-agenda) 0)
(assert (set! past-events nil) nil)

; this is wrong
(set-signal! input-1 1)
(propagate)
(assert (current-time the-agenda) 8)
(assert (set! past-events nil) nil)
(assert (get-signal sum) 0)
