; Exercise 2.44.  Define the procedure up-split used by corner-split. It is similar to right-split, except that it switches the roles of below and beside.

(load "51.scm")

(define device (make-graphics-device (car (enumerate-graphics-types))))

(define (right-split painter n)
  (if (= n 0)
      painter
      (let ((smaller (right-split painter (- n 1))))
        (beside painter (below smaller smaller)))))

(define (up-split painter n)
  (if (= n 0)
      painter
      (let ((smaller (up-split painter (- n 1))))
        (below painter (beside smaller smaller)))))

(define (corner-split painter n)
  (if (= n 0)
      painter
      (let ((up (up-split painter (- n 1)))
            (right (right-split painter (- n 1))))
        (let ((top-left (beside up up))
              (bottom-right (below right right))
              (corner (corner-split painter (- n 1))))
          (beside (below painter top-left)
                  (below bottom-right corner))))))

(graphics-clear device)
((right-split wave 4) miniframe)

(graphics-clear device)
((up-split wave 4) miniframe)

(graphics-clear device)
((corner-split wave 4) miniframe)

(graphics-close device)
