; Exercise 2.85.  This section mentioned a method for ``simplifying'' a data object by lowering it in the tower of types as far as possible. Design a procedure drop that accomplishes this for the tower described in exercise 2.83. The key is to decide, in some general way, whether an object can be lowered. For example, the complex number 1.5 + 0i can be lowered as far as real, the complex number 1 + 0i can be lowered as far as integer, and the complex number 2 + 3i cannot be lowered at all. Here is a plan for determining whether an object can be lowered: Begin by defining a generic operation project that ``pushes'' an object down in the tower. For example, projecting a complex number would involve throwing away the imaginary part. Then a number can be dropped if, when we project it and raise the result back to the type we started with, we end up with something equal to what we started with. Show how to implement this idea in detail, by writing a drop procedure that drops an object as far as possible. You will need to design the various projection operations and install project as a generic operation in the system. You will also need to make use of a generic equality predicate, such as described in exercise 2.79. Finally, use drop to rewrite apply-generic from exercise 2.84 so that it ``simplifies'' its answers.

(load "84.scm")

(define (project z) (apply-generic 'project z))

(assert (project complex0-from-real) real0)
(assert (project real0) rat0)
(assert (project rat0) integer0)
(assert (project rat05) integer0)

; this call produces an error
; (project integer0)

(define (drop z)
  (let ((projectfunc (get 'project (list (type-tag z)))))
    (if (not projectfunc)
	z
	(let ((projected (project z)))
	  (if (equ? z (raise projected))
	      (drop projected)
	      z)))))

(assert (drop integer0) integer0)
(assert (drop rat0) integer0)
(assert (drop real0) integer0)
(assert (drop complex0-from-real) integer0)
(assert (drop comp01) comp01)

(define (apply-generic op . args)
  (define ops-to-simplify (list 'add))
  (if (memq op ops-to-simplify)
      (drop (apply apply-generic-internal (cons op args)))
      (apply apply-generic-internal (cons op args))))

(assert (add complex0-from-real complex0-from-real) integer0)
(assert (add comp01 comp00) comp01)

; this call produces an error
; (add integer0 integer0)
