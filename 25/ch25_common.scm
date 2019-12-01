(load "../common.scm")

(define (attach-tag type-tag contents)
  (if (eq? type-tag 'scheme-number)
      contents
      (cons type-tag contents)))

(define (type-tag datum)
  (cond ((pair? datum) (car datum))
	((number? datum) 'scheme-number)
	(else (error "Bad tagged datum -- TYPE-TAG" datum))))

(define (contents datum)
  (cond ((pair? datum) (cdr datum))
	((number? datum) datum)
	(else (error "Bad tagged datum -- CONTENTS" datum))))

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (error
            "No method for these types -- APPLY-GENERIC"
            (list op type-tags))))))

(define (real-part z) (apply-generic 'real-part z))
(define (imag-part z) (apply-generic 'imag-part z))
(define (magnitude z) (apply-generic 'magnitude z))
(define (angle z) (apply-generic 'angle z))

(define (minus x) (apply-generic 'minus x))

(define (add x y) (apply-generic 'add x y))
; maybe ineffective, but simplest for sure
(define (sub x y) (apply-generic 'add x (minus y)))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))

(define (exp x y) (apply-generic 'exp x y))
; maybe ineffective, but simplest for sure
(define (squar x) (apply-generic 'mul x x))
(define (sqroot x) (apply-generic 'sqroot x))

(define (sine x) (apply-generic 'sine x))
(define (cosine x) (apply-generic 'cosine x))
(define (arctan x y) (apply-generic 'arctan x y))

(define (equ? x y) (apply-generic 'equ? x y))
(define (=zero? x) (apply-generic '=zero? x))

(define (raise z) (apply-generic 'raise z))
(define (project z) (apply-generic 'project z))

; neat hack: add a tag to term for proper work of apply-generic
(define (adjoin-term t tl) (apply-generic 'adjoin-term (attach-tag 'term t) tl))
(define (first-term tl) (apply-generic 'first-term tl))
(define (rest-terms tl) (apply-generic 'rest-terms tl))
(define (empty-termlist? tl) (apply-generic 'empty-termlist? tl))

(define (install-scheme-number-package)
  ; internal for package
  (define (equ-sn? x y) (= x y))
  (define zero 0)
  ; interface to rest of the system
  (define (tag x)
    (attach-tag 'scheme-number x))
  (put 'make 'scheme-number
       (lambda (x) (tag x)))
  (put 'minus '(scheme-number)
       (lambda (x) (tag (- x))))
  (put 'add '(scheme-number scheme-number)
       (lambda (x y) (tag (+ x y))))
  (put 'mul '(scheme-number scheme-number)
       (lambda (x y) (tag (* x y))))
  (put 'div '(scheme-number scheme-number)
       (lambda (x y) (tag (/ x y))))
  (put 'exp '(scheme-number scheme-number)
       (lambda (x y) (tag (expt x y)))) ; using primitive expt
  (put 'sqroot '(scheme-number)
       (lambda (x) (tag (sqrt x))))
  (put 'sine '(scheme-number)
       (lambda (x) (tag (sin x))))
  (put 'cosine '(scheme-number)
       (lambda (x) (tag (cos x))))
  (put 'arctan '(scheme-number scheme-number)
       (lambda (x y) (tag (atan x y))))
  (put 'equ? '(scheme-number scheme-number) equ-sn?)
  (put '=zero? '(scheme-number)
       (lambda (x) (equ-sn? x zero)))
  'done)

(define (make-scheme-number n)
  ((get 'make 'scheme-number) n))

(define (install-rational-package)
  ; internal for package
  (define (numer x) (car x))
  (define (denom x) (cdr x))
  (define (make-rat n d)
    (if (or (inexact? n) (inexact? d))
	(cons n d)
	(let ((g (gcd n d)))
	  (cons (/ n g) (/ d g)))))
  (define (minus-rat x)
    (make-rat (- (numer x)) (denom x)))
  (define (rat-to-number x)
    (/ (numer x) (denom x)))
  (define (add-rat x y)
    (make-rat (+ (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))
  (define (mul-rat x y)
    (make-rat (* (numer x) (numer y))
              (* (denom x) (denom y))))
  (define (div-rat x y)
    (make-rat (* (numer x) (denom y))
              (* (denom x) (numer y))))
  (define (sqroot-rat x)
    (sqrt (rat-to-number x)))
  (define (sine-rat x)
    (sin (rat-to-number x)))
  (define (cosine-rat x)
    (cos (rat-to-number x)))
  (define (arctan-rat x y)
    (atan (rat-to-number x) (rat-to-number y)))
  ; Zeroes like 0/1 and 0/2 are equal. make-rat already simplified numer and denom.
  (define (equ-rat? x y)
    (and (= (numer x) (numer y))
	 (or (= (numer x) 0)
	     (= (denom x) (denom y)))))
  (define zero (make-rat 0 1))
  ; interface to rest of the system
  (define (tag x) (attach-tag 'rational x))
  (put 'make 'rational
       (lambda (n d) (tag (make-rat n d))))
  (put 'minus '(rational)
       (lambda (x) (tag (minus-rat x))))
  (put 'add '(rational rational)
       (lambda (x y) (tag (add-rat x y))))
  (put 'mul '(rational rational)
       (lambda (x y) (tag (mul-rat x y))))
  (put 'div '(rational rational)
       (lambda (x y) (tag (div-rat x y))))
  ; To be consistent with scheme-number package, we should return typed data; ideally we shouldn't depend on scheme-number package. I had to sacrifice modularity for simplicity or vice versa, and I have prioritized simplicity.
  ; Potentially we could return rational number and drop it's type to scheme-number (see 2.85), but I don't want to cause confusion due to two different towers of types in code.
  (put 'sqroot '(rational)
       (lambda (x) (make-scheme-number (sqroot-rat x))))
  (put 'sine '(rational)
       (lambda (x) (make-scheme-number (sine-rat x))))
  (put 'cosine '(rational)
       (lambda (x) (make-scheme-number (cosine-rat x))))
  (put 'arctan '(rational rational)
       (lambda (x y) (make-scheme-number (arctan-rat x y))))
  (put 'equ? '(rational rational) equ-rat?)
  (put '=zero? '(rational)
       (lambda (x) (equ-rat? x zero)))
  ; tower of types functions
  ; Ideally tower should be separated from packages. I had to sacrifice modularity for deduplication or vice versa, and I have prioritized deduplication.
  (put 'raise '(rational)
       (lambda (x) (make-real (/ (numer x) (denom x)))))
  (put 'project '(rational)
       (lambda (x) (make-integer (round (/ (numer x) (denom x))))))
  'done)

(define (make-rational n d)
  ((get 'make 'rational) n d))

(define (install-rectangular-package)
  ; internal for package
  (define (real-part z) (car z))
  (define (imag-part z) (cdr z))
  (define (make-from-real-imag x y) (cons x y))
  (define (minus-rect z)
    (make-from-real-imag (minus (real-part z))
			 (minus (imag-part z))))
  (define (magnitude z)
    (sqroot (add (squar (real-part z))
		 (squar (imag-part z)))))
  (define (angle z)
    (arctan (imag-part z) (real-part z)))
  (define (make-from-mag-ang r a) 
    (cons (mul r (cosine a)) (mul r (sine a))))
  (define (equ-rect? x y)
    (and (equ? (real-part x) (real-part y))
	 (equ? (imag-part x) (imag-part y))))
  (define zero (make-from-real-imag 0 0))
  ; interface to the rest of the system
  (define (tag x) (attach-tag 'rectangular x))
  (put 'make-from-real-imag 'rectangular 
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'rectangular 
       (lambda (r a) (tag (make-from-mag-ang r a))))
  (put 'real-part '(rectangular) real-part)
  (put 'imag-part '(rectangular) imag-part)
  (put 'magnitude '(rectangular) magnitude)
  (put 'angle '(rectangular) angle)
  (put 'minus '(rectangular)
       (lambda (x) (tag (minus-rect x))))
  (put 'equ? '(rectangular rectangular) equ-rect?)
  (put '=zero? '(rectangular)
       (lambda (x) (equ-rect? x zero)))
  'done)

(define (install-complex-package)
  ; imported procedures from rectangular and polar packages
  (define (make-from-real-imag x y)
    ((get 'make-from-real-imag 'rectangular) x y))
  ; it would be better to use polar package here, but now it's not implemented
  (define (make-from-mag-ang r a)
    ((get 'make-from-mag-ang 'rectangular) r a))
  ; internal for package
  (define (add-complex z1 z2)
    (make-from-real-imag (add (real-part z1) (real-part z2))
                         (add (imag-part z1) (imag-part z2))))
  (define (mul-complex z1 z2)
    (make-from-mag-ang (mul (magnitude z1) (magnitude z2))
                       (add (angle z1) (angle z2))))
  (define (div-complex z1 z2)
    (make-from-mag-ang (div (magnitude z1) (magnitude z2))
                       (sub (angle z1) (angle z2))))
  ; interface to rest of the system
  (define (tag z) (attach-tag 'complex z))
  (put 'make-from-real-imag 'complex
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'complex
       (lambda (r a) (tag (make-from-mag-ang r a))))
  (put 'add '(complex complex)
       (lambda (z1 z2) (tag (add-complex z1 z2))))
  (put 'mul '(complex complex)
       (lambda (z1 z2) (tag (mul-complex z1 z2))))
  (put 'div '(complex complex)
       (lambda (z1 z2) (tag (div-complex z1 z2))))
  ; call implementations for underlying types (see 2.77)
  (put 'minus '(complex)
       (lambda (z) (tag (minus z))))
  (put 'equ? '(complex complex) equ?)
  (put '=zero? '(complex) =zero?)
  ; tower of types functions
  (put 'project '(complex)
       (lambda (z) (make-real (real-part z))))
  'done)

(define (make-complex-from-real-imag x y)
  ((get 'make-from-real-imag 'complex) x y))
(define (make-complex-from-mag-ang r a)
  ((get 'make-from-mag-ang 'complex) r a))

; representation of term
(define (make-term order coeff) (list order coeff))
(define (order term) (car term))
(define (coeff term) (cadr term))

; representation of term list
(define (install-sparse-package)
  ; internal procedures
  (define (the-empty-termlist) '())
  (define (adjoin-term term term-list)
    (if (=zero? (coeff term))
	term-list
	(cons term term-list)))
  (define (first-term term-list) (car term-list))
  (define (rest-terms term-list) (cdr term-list))
  (define (empty-termlist? term-list) (null? term-list))
  ; interface to rest of the system
  (define (tag p) (attach-tag 'sparse p))
  (put 'the-empty-termlist 'sparse
       (lambda () (tag (the-empty-termlist))))
  (put 'adjoin-term '(term sparse)
       (lambda (t tl) (tag (adjoin-term t tl))))
  (put 'first-term '(sparse)
       (lambda (tl) (first-term tl)))
  (put 'rest-terms '(sparse)
       (lambda (tl) (tag (rest-terms tl))))
  (put 'empty-termlist? '(sparse)
       (lambda (tl) (empty-termlist? tl)))
  'done)

(define (the-empty-sparse-termlist)
  ((get 'the-empty-termlist 'sparse)))
; default representation of term lists is sparse
(define (the-empty-termlist)
  (the-empty-sparse-termlist))

(define (install-polynomial-package)
  ; internal procedures
  ; term operations
  (define (minus-term term)
    (make-term (order term) (minus (coeff term))))
  (define (minus-termlist L)
    (if (empty-termlist? L)
	L
	(adjoin-term (minus-term (first-term L))
		     (minus-termlist (rest-terms L)))))
  (define (add-terms L1 L2)
    (cond ((empty-termlist? L1) L2)
	  ((empty-termlist? L2) L1)
	  (else
	   (let ((t1 (first-term L1)) (t2 (first-term L2)))
	     (cond ((> (order t1) (order t2))
		    (adjoin-term
		     t1 (add-terms (rest-terms L1) L2)))
		   ((< (order t1) (order t2))
		    (adjoin-term
		     t2 (add-terms L1 (rest-terms L2))))
		   (else
		    (adjoin-term
		     (make-term (order t1)
				(add (coeff t1) (coeff t2)))
		     (add-terms (rest-terms L1)
				(rest-terms L2)))))))))
  (define (sub-terms L1 L2)
    (add-terms L1 (minus-termlist L2)))
  (define (mul-term-by-all-terms t1 L)
    (if (empty-termlist? L)
	(the-empty-termlist)
	(let ((t2 (first-term L)))
	  (adjoin-term
	   (make-term (+ (order t1) (order t2))
		      (mul (coeff t1) (coeff t2)))
	   (mul-term-by-all-terms t1 (rest-terms L))))))
  (define (mul-terms L1 L2)
    (if (empty-termlist? L1)
	(the-empty-termlist)
	(add-terms (mul-term-by-all-terms (first-term L1) L2)
		   (mul-terms (rest-terms L1) L2))))
  (define (div-terms L1 L2)
    (if (empty-termlist? L1)
	(list (the-empty-termlist) (the-empty-termlist))
	(let ((t1 (first-term L1))
	      (t2 (first-term L2)))
	  (if (> (order t2) (order t1))
	      (list (the-empty-termlist) L1)
	      (let ((new-c (div (coeff t1) (coeff t2)))
		    (new-o (- (order t1) (order t2))))
		(let ((rest-of-result
		       ; compute rest of result recursively
		       (div-terms (sub-terms L1
					     (mul-terms L2
							(adjoin-term (make-term new-o new-c)
								     (the-empty-termlist))))
				  L2)))
		  ; form complete result
		  (list (adjoin-term (make-term new-o new-c) (car rest-of-result))
			(cadr rest-of-result))))))))
  ; representation of poly
  (define (make-poly variable term-list)
    (cons variable term-list))
  (define (variable p) (car p))
  (define (term-list p) (cdr p))
  (define (variable? x) (symbol? x))
  (define (same-variable? v1 v2)
    (and (variable? v1) (variable? v2) (eq? v1 v2)))
  ; poly operations
  (define (minus-poly p)
    (make-poly (variable p)
	       (minus-termlist (term-list p))))
  (define (add-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
	(make-poly (variable p1)
		   (add-terms (term-list p1)
			      (term-list p2)))
	(error "Polys not in same var -- ADD-POLY"
	       (list p1 p2))))
  (define (mul-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
	(make-poly (variable p1)
		   (mul-terms (term-list p1)
			      (term-list p2)))
	(error "Polys not in same var -- MUL-POLY"
	       (list p1 p2))))
  (define (div-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
	(let ((res-terms (div-terms (term-list p1)
				    (term-list p2))))
	  (list (make-poly (variable p1) (car res-terms))
		(make-poly (variable p1) (cadr res-terms))))
	(error "Polys not in same var -- DIV-POLY"
	       (list p1 p2))))
  ; interface to rest of the system
  (define (tag p) (attach-tag 'polynomial p))
  (put 'make 'polynomial
       (lambda (var terms) (tag (make-poly var terms))))
  (put 'minus '(polynomial)
       (lambda (p) (tag (minus-poly p))))
  (put 'add '(polynomial polynomial)
       (lambda (p1 p2) (tag (add-poly p1 p2))))
  (put 'mul '(polynomial polynomial)
       (lambda (p1 p2) (tag (mul-poly p1 p2))))
  (put 'div '(polynomial polynomial)
       (lambda (L1 L2)
	 (let ((res (div-poly L1 L2)))
	   (list (tag (car res))
		 (tag (cadr res))))))
  (put '=zero? '(polynomial)
       (lambda (p) (empty-termlist? (term-list p))))
  'done)

(define (make-polynomial var terms)
  ((get 'make 'polynomial) var terms))

(install-scheme-number-package)
(install-rational-package)
(install-rectangular-package)
(install-complex-package)
(install-sparse-package)
(install-polynomial-package)

(define sn0 (make-scheme-number 0))
(define sn1 (make-scheme-number 1))

(define rat0 (make-rational 0 100))
(define rat1 (make-rational 1 1))
(define rat05 (make-rational 1 2))

(define comp00 (make-complex-from-real-imag 0 0))
(define comp01 (make-complex-from-real-imag 0 1))
(define comp10 (make-complex-from-real-imag 1 0))
(define comp11 (make-complex-from-real-imag 1 1))

(define empty-poly (make-polynomial 'x (the-empty-termlist)))
(define empty-term (make-term 0 empty-poly))
(define term-01 (make-term 0 1))
(define sample-term-list (adjoin-term term-01 (the-empty-termlist)))
(define sample-poly (make-polynomial 'x sample-term-list))

(define *coercion-table* (make-hash-table))

(define (put-coercion from to proc)
  (hash-table/put! *coercion-table* (list from to) proc))

(define (get-coercion from to)
  (hash-table/get *coercion-table* (list from to) #f))
