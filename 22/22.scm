; Exercise 2.22.  Louis Reasoner tries to rewrite the first square-list procedure of exercise 2.21 so that it evolves an iterative process. Unfortunately, defining square-list this way produces the answer list in the reverse order of the one desired. Why?

(load "ch22_common.scm")

(define (square-list-3 items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things) 
              (cons (square (car things))
                    answer))))
  (iter items nil))

; This function adds new square to the list before (instead of after) previous squares.

; Louis then tries to fix his bug by interchanging the arguments to cons. This doesn't work either. Explain.

(define (square-list-4 items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons answer
                    (square (car things))))))
  (iter items nil))

; Here pairs are consed in wrong order, reverse to pair order in list:
; (list <a1> <a2> ... <an>) = (cons <a1> (cons <a2> (cons ... (cons <an> nil) ...)))
; Also, nil is not on the end of list, where it should be.

(assert '(16 9 4 1) (square-list-3 '(1 2 3 4)))
(assert (cons (cons (cons (cons nil 1) 4) 9) 16) (square-list-4 '(1 2 3 4)))
