; Exercise 2.75.  Implement the constructor make-from-mag-ang in message-passing style. This procedure should be analogous to the make-from-real-imag procedure given above.

(load "ch24_common.scm")

(define (make-from-mag-ang mag ang)
  (define (dispatch op)
    (cond ((eq? op 'real-part) (* mag (cos ang)))
          ((eq? op 'imag-part) (* mag (sin ang)))
          ((eq? op 'magnitude) mag)
          ((eq? op 'angle) ang)
          (else (error "Unknown op -- MAKE-FROM-MAG-ANG" op))))
  dispatch)

(define complex-num (make-from-mag-ang 1 2))
(assert (complex-num 'real-part) -.4161468365471424)
(assert (complex-num 'imag-part) .9092974268256817)
(assert (complex-num 'magnitude) 1)
(assert (complex-num 'angle) 2)
; gives an error
; (complex-num '123)
