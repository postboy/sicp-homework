; Exercise 2.53.  What would the interpreter print in response to evaluating each of the following expressions?

(load "ch23_common.scm")

(define (memq item x)
  (cond ((null? x) false)
        ((eq? item (car x)) x)
        (else (memq item (cdr x)))))

(assert '(a b c) (list 'a 'b 'c))

(assert '((george)) (list (list 'george)))

(assert '((y1 y2)) (cdr '((x1 x2) (y1 y2))))

(assert '(y1 y2) (cadr '((x1 x2) (y1 y2))))

(assert #f (pair? (car '(a short list))))

(assert #f (memq 'red '((red shoes) (blue socks))))

(assert '(red shoes blue socks) (memq 'red '(red shoes blue socks)))
