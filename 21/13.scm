; Exercise 2.13.  Show that under the assumption of small percentage tolerances there is a simple formula for the approximate percentage tolerance of the product of two intervals in terms of the tolerances of the factors. You may simplify the problem by assuming that all numbers are positive.

(load "12.scm")

(define inexact-2 (make-center-percent 2 2))
(define inexact-20 (make-center-percent 20 1))

(assert 2.9994001199760048 (percent (mul-interval inexact-2 inexact-20)))

; Let's suppose that all numbers are positive.
; Based on 2.11, multiplication of two positive intervals is
; (make-interval (* (lb x) (lb y)) (* (ub x) (ub y))))
; Given the definitions from 2.9
; (width i) = (/ (- (upper-bound i) (lower-bound i)) 2)), so
; (width mul) = (/ (- (* (ub x) (ub y)) (* (lb x) (lb y))) 2))
; Given the definitions from 2.12
; (lb a) = (- (center a) (width a)),
; (ub a) = (+ (center a) (width a)), where
; (width a) = (* (center a) (/ (percent a) 100))
; Let's see at the heart of (width mul). It looks like this:
; (a+c)*(b+d) - (a-c)*(b-d) = ab + ad + bc + cd - (ab - ad - bc + cd) = 2(ad + bc)
; It means that
; (width mul) = 2*((center x)*(width y) + (center y)*(width x))/2 = (center x)*(width y) + (center y)*(width x)
; Let's substitute formula for (width a):
; (width mul) = (center x)*(center y)*(percent y)/100 + (center y)*(center x)*(percent x)/100 = (center x)*(center y)*((percent x) + (percent y))/100
; Under the assumption of small percentage tolerances we can say that
; (center mul) ~ (center x) * ((center y))
; If so, then
; (percent mul) = (* (/ (width mul) (center mul)) 100.0)) = ((percent x) + (percent y)) / 100 * 100 = (percent x) + (percent y)
