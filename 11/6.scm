; Exercise 1.6.  Alyssa P. Hacker doesn't see why if needs to be provided as a special form. ``Why can't I just define it as an ordinary procedure in terms of cond?'' she asks. Alyssa's friend Eva Lu Ator claims this can indeed be done, and she defines a new version of if:

(load "ch11_common.scm")

(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause)))

; Eva demonstrates the program for Alyssa:

(assert 5 (new-if (= 2 3) 0 5))
(assert 0 (new-if (= 1 1) 0 5))

; Delighted, Alyssa uses new-if to rewrite the square-root program:

(define (sqrt-iter guess x)
  (new-if (good-enough? guess x)
          guess
          (sqrt-iter (improve guess x)
                     x)))

(sqrt 1)

; What happens when Alyssa attempts to use this to compute square roots? Explain.

; Evaluation will produce an ethernal expansion (ethernal cycle). Since new-if is an ordinary form, then to apply new-if operator we should first compute all of it's operands. It this case, we should compute result of another expression with sqrt-iter as operand, which in turn get us back to the original problem (but some memory is already wasted). Scheme will report this situation as "Aborting!: maximum recursion depth exceeded".
