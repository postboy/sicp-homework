; Exercise 1.2.  Translate the following expression into prefix form <...>

(load "ch11_common.scm")

; assert don't work here
;(assert (/ -37 150)
	(/ (+ 5
	      4
	      (- 2
		 (- 3
		    (+ 6
		       (/ 4 5)))))
	   (* 3
	      (- 6 2)
	      (- 2 7)));)
