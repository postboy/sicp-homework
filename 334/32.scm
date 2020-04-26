; Exercise 3.32.  The procedures to be run during each time segment of the agenda are kept in a queue. Thus, the procedures for each segment are called in the order in which they were added to the agenda (first in, first out). Explain why this order must be used. In particular, trace the behavior of an and-gate whose inputs change from 0,1 to 1,0 in the same segment and say how the behavior would differ if we stored a segment's procedures in an ordinary list, adding and removing procedures only at the front (last in, first out).

(load "ch334_common.scm")

; working implementation

(define the-agenda (make-agenda))
(define input-1 (make-wire))
(define input-2 (make-wire))
(define output (make-wire))

(probe 'output output)
(assert (current-time the-agenda) 0)
(assert (set! past-events nil) '((0 output 0)))

(and-gate input-1 input-2 output)
(set-signal! input-1 0)
(set-signal! input-2 1)
(propagate)
(assert (current-time the-agenda) (* and-gate-delay 1))
(assert (set! past-events nil) nil)

; System processes input-1 and decides that output will become (1 and 1) = 1 on time 6. This is intermediate result because we haven't processed all inputs yet.
; System processes input-2 and decides that output will become (1 and 0) = 0 on time 6. This is final result because we have already processed all inputs.
; As we can see, everything works right. Intermediate result is overwritten by the final result because we used queue (first in, first out) for storing actions (in our case, after-delay set-signal!).
(set-signal! input-1 1)
(set-signal! input-2 0)
(propagate)
(assert (current-time the-agenda) (* and-gate-delay 2))
(assert (set! past-events nil) '((6 output 0) (6 output 1)))

(set-signal! input-1 0)
(set-signal! input-2 1)
(propagate)
(assert (current-time the-agenda) (* and-gate-delay 3))
(assert (set! past-events nil) nil)

; broken implementation

; hack to minimize changes: substitute a queue with a list
(define (make-queue)
  (let ((front-ptr nil))
    (define (empty-queue?)
      (null? front-ptr))
    (define (front-queue)
      (if (empty-queue?)
	  (error "FRONT called with an empty queue")
	  (car front-ptr)))
    (define (insert-queue! item)
	(set! front-ptr (cons item front-ptr))
	#t)
    (define (delete-queue!)
      (if (empty-queue?)
	  (error "DELETE! called with an empty queue")
	  (begin (set! front-ptr (cdr front-ptr))
		 #t)))
    (define (dispatch m)
      (cond ((eq? m 'empty-queue?) (empty-queue?))
	    ((eq? m 'front-queue) (front-queue))
	    ((eq? m 'insert-queue!) insert-queue!)
	    ((eq? m 'delete-queue!) (delete-queue!))
	    (else (error "Undefined operation -- MAKE-QUEUE" m))))
    dispatch))

(define the-agenda (make-agenda))
(define input-1 (make-wire))
(define input-2 (make-wire))
(define output (make-wire))

(probe 'output output)
(assert (current-time the-agenda) 0)
(assert (set! past-events nil) '((0 output 0)))

(and-gate input-1 input-2 output)
(set-signal! input-1 0)
(set-signal! input-2 1)
(propagate)
(assert (current-time the-agenda) (* and-gate-delay 1))
(assert (set! past-events nil) nil)

; As we can see, this is wrong. Final result is overwritten by the intermediate result because we used list (last in, first out) for storing actions (in our case, after-delay set-signal!). First set-signal! is an empty operation because the output doesn't change.
(set-signal! input-1 1)
(set-signal! input-2 0)
(propagate)
(assert (current-time the-agenda) (* and-gate-delay 2))
(assert (set! past-events nil) '((6 output 1)))

(set-signal! input-1 0)
(set-signal! input-2 1)
(propagate)
(assert (current-time the-agenda) (* and-gate-delay 3))
(assert (set! past-events nil) '((9 output 0)))
