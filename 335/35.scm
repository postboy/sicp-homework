; Exercise 3.35.  Ben Bitdiddle tells Louis that one way to avoid the trouble in exercise 3.34 is to define a squarer as a new primitive constraint. Fill in the missing portions in Ben's outline for a procedure to implement such a constraint:

(load "ch335_common.scm")

(define (squarer a b)
  (define (process-new-value)
    (if (has-value? b)
        (if (< (get-value b) 0)
            (error "square less than 0 -- SQUARER" (get-value b))
            (set-value! a
                       (sqrt (get-value b))
                       me))
        (if (has-value? a)
            (set-value! b
                       (square (get-value a))
                       me))))
  (define (process-forget-value)
    (forget-value! a me)
    (forget-value! b me)
    (process-new-value))
  (define (me request)
    (cond ((eq? request 'I-have-a-value)
           (process-new-value))
          ((eq? request 'I-lost-my-value)
           (process-forget-value))
          (else
           (error "Unknown request -- SQUARER" request))))
  (connect a me)
  (connect b me)
  me)

(define root (make-connector))
(probe 'root root)
(define square-value (make-connector))
(probe 'square-value square-value)

(squarer root square-value)
(assert (set! past-events nil) nil)

(set-value! root 10 'user)
(assert (set! past-events nil) '((root 10) (square-value 100)))

(forget-value! root 'user)
(assert (set! past-events nil) '((root "?") (square-value "?")))

(set-value! square-value 100 'user)
(assert (set! past-events nil) '((square-value 100) (root 10)))
