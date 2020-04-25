; Exercise 3.25.  Generalizing one- and two-dimensional tables, show how to implement a table in which values are stored under an arbitrary number of keys and different values may be stored under different numbers of keys. The lookup and insert! procedures should take as input a list of keys used to access the table.

(load "ch33_common.scm")

(define (make-table)
  (let ((local-table (list '*table*)))
    (define (assoc key records)
      (cond ((not (pair? records)) false)
	    ((not (pair? (car records))) false)
	    ((equal? key (caar records)) (car records))
	    (else (assoc key (cdr records)))))
    (define (lookup-internal table keys)
      (if (null? keys)
	  (cdr table)
	  (let ((record (assoc (car keys) (cdr table))))
	    (if record
		(lookup-internal record (cdr keys))
		false))))
    (define (lookup keys)
      (lookup-internal local-table keys))
    (define (insert!-internal value table keys)
      (if (null? keys)
	  (begin (set-cdr! table value)
		 true)
	  (let ((record (assoc (car keys) (cdr table))))
	    (if record
		(insert!-internal value record (cdr keys))
		(begin (set-cdr! table
				 (cons (cons (car keys) nil)
				       (cdr table)))
		       (insert!-internal value (cadr table) (cdr keys)))))))
    (define (insert! value keys)
      (insert!-internal value local-table keys))
    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc!) insert!)
            (else (error "Unknown operation -- TABLE" m))))
    dispatch))

(define (lookup table . keys)
  ((table 'lookup-proc) keys))
(define (insert! value table . keys)
  ((table 'insert-proc!) value keys))

(define table (make-table))
(assert (lookup table) nil)
(assert (lookup table 'a) #f)
(assert (insert! 5 table 'a) #t)
(assert (lookup table 'a) 5)
(assert (lookup table 'a 'b) #f)
(assert (insert! 6 table 'a) #t)
(assert (lookup table 'a) 6)
(assert (lookup table 'b 'c) #f)
(assert (insert! 7 table 'b 'c) #t)
(assert (lookup table 'b 'c) 7)
(assert (insert! 8 table 'b 'c) #t)
(assert (insert! 0 table 'b 'd) #t)
(assert (lookup table 'a) 6)
(assert (lookup table 'b 'c) 8)
(assert (lookup table 'b 'd) 0)
(assert (lookup table 'b) (list (cons 'd 0) (cons 'c 8)))
(assert (lookup table) (list (list 'b (cons 'd 0) (cons 'c 8)) (cons 'a 6)))
(assert (insert! 9 table 'b) #t)
(assert (lookup table 'b) 9)
(assert (lookup table 'b 'c) #f)
(assert (lookup table) (list (cons 'b 9) (cons 'a 6)))