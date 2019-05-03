; Exercise 2.25.  Give combinations of cars and cdrs that will pick 7 from each of the following lists:

(load "ch22_common.scm")

(assert 7 (cadr (caddr '(1 3 (5 7) 9))))
(assert 7 (caar '((7))))
(assert 7 (cadadr (cadadr (cadadr '(1 (2 (3 (4 (5 (6 7))))))))))
