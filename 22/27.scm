; Exercise 2.27.  Modify your reverse procedure of exercise 2.18 to produce a deep-reverse procedure that takes a list as argument and returns as its value the list with its elements reversed and with all sublists deep-reversed as well.

(load "18.scm")

(define x '((1 2) (3 4)))

(define (deep-reverse l)
  (if (not (pair? l))
      l
      (append (deep-reverse (cdr l)) (list (deep-reverse (car l))))))

(assert '((3 4) (1 2)) (reverse x))
(assert '((4 3) (2 1)) (deep-reverse x))
(assert '() (deep-reverse (list)))
