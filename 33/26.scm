; Exercise 3.26.  To search a table as implemented above, one needs to scan through the list of records. This is basically the unordered list representation of section 2.3.3. For large tables, it may be more efficient to structure the table in a different manner. Describe a table implementation where the (key, value) records are organized using a binary tree, assuming that keys can be ordered in some way (e.g., numerically or alphabetically). (Compare exercise 2.66 of chapter 2.)

(cd "../23")
(load "66.scm")
(cd "../33")

(define (make-table)
  (let ((local-table (list '*table*)))
    (define (lookup-internal key)
      (let ((record (lookup key (cdr local-table))))
	(if record
	    (value record)
	    #f)))
    (define (make-subtree given-key given-value)
      (make-tree (make-record given-key given-value) nil nil))
    (define (insert-in-tree! tree given-key given-value)
      (cond ((= given-key (key (entry tree)))
	     (set-value! (entry tree) given-value))
        ((< given-key (key (entry tree)))
         (if (null? (left-branch tree))
	     (set-left-branch! tree (make-subtree given-key given-value))
	     (insert-in-tree! (left-branch tree) given-key given-value)))
        (else
	 (if (null? (right-branch tree))
	     (set-right-branch! tree (make-subtree given-key given-value))
	     (insert-in-tree! (right-branch tree) given-key given-value)))))
    (define (insert-internal! given-key given-value)
      (let ((tree (cdr local-table)))
	(if (null? tree)
	    (set-cdr! local-table (make-subtree given-key given-value))
	    (insert-in-tree! tree given-key given-value)))
      #t)
    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup-internal)
            ((eq? m 'insert-proc!) insert-internal!)
            (else (error "Unknown operation -- TABLE" m))))
    dispatch))

(define (lookup-table table key)
  ((table 'lookup-proc) key))

(define (insert-table! table key value)
  ((table 'insert-proc!) key value))

(define table (make-table))

(assert (lookup-table table 5) #f)
(assert (insert-table! table 5 'five-tmp) #t)
(assert (lookup-table table 5) 'five-tmp)

(assert (insert-table! table 5 'five) #t)
(assert (lookup-table table 5) 'five)

(assert (lookup-table table 10) #f)
(assert (insert-table! table 10 'ten) #t)
(assert (lookup-table table 10) 'ten)

(assert (lookup-table table 0) #f)
(assert (insert-table! table 0 'zero) #t)
(assert (lookup-table table 0) 'zero)

(assert (lookup-table table 2) #f)
(assert (insert-table! table 2 'two) #t)
(assert (lookup-table table 2) 'two)

(assert (lookup-table table 8) #f)
(assert (insert-table! table 8 'eight) #t)
(assert (lookup-table table 8) 'eight)

(assert (lookup-table table 0) 'zero)
(assert (lookup-table table 2) 'two)
(assert (lookup-table table 5) 'five)
(assert (lookup-table table 8) 'eight)
(assert (lookup-table table 10) 'ten)
(assert (lookup-table table 11) #f)
