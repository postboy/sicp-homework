(load "common.scm")

(assert #t (assert 0 0))
(assert #t (assert 'a 'a))
(assert #t (assert 1/4 1/4))
(assert #t (assert 0.1 0.1))
; following lines cause error messages on console
(assert #f (assert 0 1))
(assert #f (assert 'a 'b))
(assert #f (assert 0 'a))
(assert #f (assert 0 0.1))
(assert #f (assert 0 1/4))
