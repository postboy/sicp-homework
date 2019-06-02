; Exercise 2.54.  Two lists are said to be equal? if they contain equal elements arranged in the same order. <...> To be more precise, we can define equal? recursively in terms of the basic eq? equality of symbols by saying that a and b are equal? if they are both symbols and the symbols are eq?, or if they are both lists such that (car a) is equal? to (car b) and (cdr a) is equal? to (cdr b). Using this idea, implement equal? as a procedure.

(load "ch23_common.scm")

; assert is implemented via equal?, so here we define my-equal?
(define (my-equal? a b)
  (cond ((and (list? a) (not (list? b))) #f)
	((and (list? b) (not (list? a))) #f)
	((not (list? a)) (eq? a b))
	((null? a) (null? b))
	((null? b) #f)
	(else (and (my-equal? (car a) (car b))
		   (my-equal? (cdr a) (cdr b))))))

(assert #t (my-equal? #f #f))
(assert #t (my-equal? 0 0))
(assert #t (my-equal? 'a 'a))
(assert #t (my-equal? '(this is a list) '(this is a list)))

; eq? is strict, that's ok:
(assert #f (my-equal? 1/4 1/4))
(assert #f (my-equal? 0.1 0.1))

(assert #f (my-equal? #f #t))
(assert #f (my-equal? 0 1))
(assert #f (my-equal? 'a 'b))
(assert #f (my-equal? 0 'a))
(assert #f (my-equal? 0 0.1))
(assert #f (my-equal? 0 1/4))
(assert #f (my-equal? 'a nil))
(assert #f (my-equal? '(this is a list) nil))
(assert #f (my-equal? '(this is a list) '(this (is a) list)))
