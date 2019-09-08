; Exercise 2.84.  Using the raise operation of exercise 2.83, modify the apply-generic procedure so that it coerces its arguments to have the same type by the method of successive raising, as discussed in this section. You will need to devise a way to test which of two types is higher in the tower. Do this in a manner that is ``compatible'' with the rest of the system and will not lead to problems in adding new levels to the tower.

(load "83.scm")

(define (apply-generic-internal op . args)
  (define (no-method-defined type-tags)
    (error "No method for these types" (list op type-tags)))
  (define tower (list 'integer 'rational 'real 'complex))
  (define type-tags (map type-tag args))
  (define proc (get op type-tags))
  (cond (proc
	 (apply proc (map contents args)))
	((not (= (length args) 2))
	 (no-method-defined type-tags))
	(else
	 (let ((rest1 (memq (car type-tags) tower))
	       (rest2 (memq (cadr type-tags) tower)))
	   (if (not (and (list? rest1) (list? rest2)))
	       (no-method-defined type-tags)
	       (let ((len1 (length rest1))
		     (len2 (length rest2))
		     (a1 (car args))
		     (a2 (cadr args)))
		 (cond ((> len1 len2) ; in tower type1 appears before type2
			(apply-generic op (raise a1) a2))
		       ((< len1 len2) ; opposite
			(apply-generic op a1 (raise a2)))
		       (else ; type1 = type2
			(no-method-defined type-tags)))))))))

(define (apply-generic op . args)
  (apply apply-generic-internal (cons op args)))

(assert (add complex0-from-real complex0-from-real) complex0-from-real)
(assert (add integer0 complex0-from-real) complex0-from-real)
(assert (add complex0-from-real integer0) complex0-from-real)

; this call produces an error
; (add integer0 integer0)
