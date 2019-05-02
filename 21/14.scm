; Exercise 2.14.  Demonstrate that Lem is right. Investigate the behavior of the system on a variety of arithmetic expressions. Make some intervals A and B, and use them in computing the expressions A/A and A/B. You will get the most insight by using intervals whose width is a small percentage of the center value. Examine the results of the computation in center-percent form (see exercise 2.12).

(load "13.scm")

(define (par1 r1 r2)
  (div-interval (mul-interval r1 r2)
                (add-interval r1 r2)))

(define (par2 r1 r2)
  (let ((one (make-interval 1 1))) 
    (div-interval one
                  (add-interval (div-interval one r1)
                                (div-interval one r2)))))

(assert 1.0016006402561024 (center (par1 inexact-2 inexact-2)))
(assert 1.0 (center (par2 inexact-2 inexact-2)))
(assert 5.993607670795051 (percent (par1 inexact-2 inexact-2)))
(assert 2.0000000000000018 (percent (par2 inexact-2 inexact-2)))

(assert 1.8193570143884892 (center (par1 inexact-20 inexact-2)))
(assert 1.818166790097334 (center (par2 inexact-20 inexact-2)))
(assert 4.088971269694153 (percent (par1 inexact-20 inexact-2)))
(assert 1.909115705635266 (percent (par2 inexact-20 inexact-2)))

; We can see that par1 and par2 give similar (albeit not the same) results, but par2 gives more exact result.

(assert 1.000800320128051 (center (div-interval inexact-2 inexact-2)))
(assert 3.998400639744109 (percent (div-interval inexact-2 inexact-2)))
(assert 10.006002400960384 (center (div-interval inexact-20 inexact-2)))
(assert 2.999400119976007 (percent (div-interval inexact-20 inexact-2)))

; div-interval is trivially expressed via mul-interval (see 2.9), so here we can see the same situation as in 2.13: (percent div) ~ (percent x) + (percent y), if percents of x and y are small.
