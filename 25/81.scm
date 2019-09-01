; Exercise 2.81.  Louis Reasoner has noticed that apply-generic may try to coerce the arguments to each other's type even if they already have the same type. Therefore, he reasons, we need to put procedures in the coercion table to "coerce" arguments of each type to their own type. For example, in addition to the scheme-number->complex coercion shown above, he would do:

(load "ch25_common.scm")

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (if (= (length args) 2)
              (let ((type1 (car type-tags))
                    (type2 (cadr type-tags))
                    (a1 (car args))
                    (a2 (cadr args)))
                (let ((t1->t2 (get-coercion type1 type2))
                      (t2->t1 (get-coercion type2 type1)))
                  (cond (t1->t2
                         (apply-generic op (t1->t2 a1) a2))
                        (t2->t1
                         (apply-generic op a1 (t2->t1 a2)))
                        (else
                         (error "No method for these types"
                                (list op type-tags))))))
              (error "No method for these types"
                     (list op type-tags)))))))

(define (scheme-number->scheme-number n) n)
(define (complex->complex z) z)
(put-coercion 'scheme-number 'scheme-number
              scheme-number->scheme-number)
(put-coercion 'complex 'complex complex->complex)

; a. With Louis's coercion procedures installed, what happens if apply-generic is called with two arguments of type scheme-number or two arguments of type complex for an operation that is not found in the table for those types? For example, assume that we've defined a generic exponentiation operation:

(define (exp x y) (apply-generic 'exp x y))

; and have put a procedure for exponentiation in the Scheme-number package but not in any other package: <...>
; What happens if we call exp with two complex numbers as arguments?

(define comp00 (make-complex-from-real-imag 0 0))

; (exp comp00 comp00)
; This call will never return because after useless "coercion" we'll get exactly the same operation as we had before. Execution does not proceed towards solution with every recursion step, and this is fundamentally wrong. Note that we won't get "Aborting!: maximum recursion depth exceeded" message unless we change
; (apply-generic op (t1->t2 a1) a2))
; to something like
; (cons (apply-generic op (t1->t2 a1) a2)) nil)
; This situation probably occurs due to tail call optimization requirement for Scheme implementations.

; b. Is Louis correct that something had to be done about coercion with arguments of the same type, or does apply-generic work correctly as is?

; In general, Louis is right because some operation can be undefined for arguments of this type but defined if some arguments will be promoted to higher-order types. I don't know how "real-world-ish" this situation is.

; c. Modify apply-generic so that it doesn't try coercion if the two arguments have the same type.

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (if (= (length args) 2)
              (let ((type1 (car type-tags))
                    (type2 (cadr type-tags))
                    (a1 (car args))
                    (a2 (cadr args)))
                (let ((t1->t2 (get-coercion type1 type2))
                      (t2->t1 (get-coercion type2 type1)))
                  (cond ((eq? type1 type2)
			 (error "No method for these types"
                                (list op type-tags)))
			(t1->t2
                         (apply-generic op (t1->t2 a1) a2))
                        (t2->t1
                         (apply-generic op a1 (t2->t1 a2)))
                        (else
                         (error "No method for these types"
                                (list op type-tags))))))
              (error "No method for these types"
                     (list op type-tags)))))))

; this call produces an error
; (exp comp00 comp00)
