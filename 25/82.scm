; Exercise 2.82.  Show how to generalize apply-generic to handle coercion in the general case of multiple arguments. One strategy is to attempt to coerce all the arguments to the type of the first argument, then to the type of the second argument, and so on. Give an example of a situation where this strategy (and likewise the two-argument version given above) is not sufficiently general. (Hint: Consider the case where there are some suitable mixed-type operations present in the table that will not be tried.)

(load "ch25_common.scm")

(define (scheme-number->complex n)
  (make-complex-from-real-imag (contents n) 0))

(put-coercion 'scheme-number 'complex scheme-number->complex)

; we don't have to coerce arguments of same types
(define (get-coercion-or-identity from to)
  (if (eq? from to)
      identity
      (get-coercion from to)))

; do arg-types list can be coerced to type?
(define (coerces-to type arg-types)
  (cond ((null? arg-types) #t)
	((get-coercion-or-identity (car arg-types) type) (coerces-to type (cdr arg-types)))
	(else #f)))

; do arg-types list can be coerced to any member of candidate-types list?
; returns this member or #f
(define (general-type candidate-types arg-types)
  (cond ((null? candidate-types) #f)
	((coerces-to (car candidate-types) arg-types) (car candidate-types))
	(else (general-type (cdr candidate-types) arg-types))))

; convert args to type. it's caller responsibility to check if this is possible
(define (coerce-list-to type args)
  (if (null? args)
      nil
      (cons
       ((get-coercion-or-identity (type-tag (car args)) type) (car args))
       (coerce-list-to type (cdr args)))))

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
	  (let ((gen-type (general-type type-tags type-tags)))
	    (if gen-type
		(let ((args (coerce-list-to gen-type args)))
		  (let ((type-tags (map type-tag args)))
		    (let ((proc (get op type-tags)))
		      (if proc
			  (apply proc (map contents args))
			  (error "No method for these types"
				 (list op type-tags))))))
		(error "No method for these types"
		       (list op type-tags))))))))

(define complex-only-list '(complex))
(define complex-first-list '(complex scheme-number))
(define complex-last-list '(scheme-number complex))
(assert (general-type complex-first-list complex-first-list) 'complex)
(assert (general-type complex-first-list complex-last-list) 'complex)
(assert (general-type complex-last-list complex-only-list) 'complex)

(assert (coerce-list-to 'complex (list sn1 sn1)) (list comp10 comp10))

(assert (equ? comp00 sn1) #f)
(assert (equ? sn1 comp00) #f)
(assert (equ? comp10 sn1) #t)
(assert (equ? sn1 comp10) #t)

; Let's suppose that we have an operation defined for types (complex rational). What if we want to apply it to numbers with types (complex scheme-number)? In principle we could perform raising scheme-number to rational and then apply a defined function to numbers with types (complex rational), but current apply-generic implementation won't do that. It will only try to find function for types (complex scheme-number), then for types (complex complex), where second complex number is made from scheme-number.

; Another interesting case is calling a function for a high-level type with an argument of low-level type, ex. (real-part 0). In principle we could perform raising scheme-number to complex and then apply a defined function, but current apply-generic implementation won't do that. It will only try to find function for types (scheme-number), then again for types (scheme-number).
