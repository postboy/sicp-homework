(load "ch1_common.scm")

(assert #t (assert 0 0))
(assert #t (assert 'a 'a))
; following lines cause error messages on console
(assert #f (assert 0 1))
(assert #f (assert 'a 'b))
(assert #f (assert 0 'a))
