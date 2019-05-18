; Exercise 2.45.  Right-split and up-split can be expressed as instances of a general splitting operation. Define a procedure split with the property that evaluating <...> produces procedures right-split and up-split with the same behaviors as the ones already defined.

(load "51.scm")

(define device (make-graphics-device (car (enumerate-graphics-types))))

(define (split out-comb in-comb)
  (lambda (painter n)
    (if (= n 0)
        painter
        (let ((smaller ((split out-comb in-comb) painter (- n 1))))
          (out-comb painter (in-comb smaller smaller))))))

(define right-split (split beside below))
(define up-split (split below beside))

(graphics-clear device)
((right-split wave 4) miniframe)

(graphics-clear device)
((up-split wave 4) miniframe)

(graphics-close device)
