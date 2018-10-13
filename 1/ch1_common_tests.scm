(load "ch1_common.scm")

(assert 0 0)   ; #t
(assert 0 1)   ; #f
(assert 'a 'a) ; #t
(assert 'a 'b) ; #f
(assert 0 'a)  ; #f
