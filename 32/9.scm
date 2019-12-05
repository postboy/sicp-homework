; Exercise 3.9.  In section 1.2.1 we used the substitution model to analyze two procedures for computing factorials, a recursive version <...> and an iterative version <...>. Show the environment structures created by evaluating (factorial 6) using each version of the factorial procedure.

(load "ch32_common.scm")

(define (factorial n)
  (if (= n 1)
      1
      (* n (factorial (- n 1)))))

(assert (factorial 6) 720)

; GLOBAL
; E1 | n:6, link from factorial, link to GLOBAL
; E2 | n:5, link from factorial, link to GLOBAL
; E3 | n:4, link from factorial, link to GLOBAL
; E4 | n:3, link from factorial, link to GLOBAL
; E5 | n:2, link from factorial, link to GLOBAL
; E6 | n:1, link from factorial, link to GLOBAL

(define (fact-iter product counter max-count)
  (if (> counter max-count)
      product
      (fact-iter (* counter product)
                 (+ counter 1)
                 max-count)))

(define (factorial n)
  (fact-iter 1 1 n))

(assert (factorial 6) 720)

; GLOBAL
; E1 | n:6, link from factorial, link to GLOBAL
; E2 | product:1   counter:1 max-count:6, link from fact-iter, link to GLOBAL
; E3 | product:1   counter:2 max-count:6, link from fact-iter, link to GLOBAL
; E4 | product:2   counter:3 max-count:6, link from fact-iter, link to GLOBAL
; E5 | product:6   counter:4 max-count:6, link from fact-iter, link to GLOBAL
; E6 | product:24  counter:5 max-count:6, link from fact-iter, link to GLOBAL
; E7 | product:120 counter:6 max-count:6, link from fact-iter, link to GLOBAL
; E8 | product:720 counter:7 max-count:6, link from fact-iter, link to GLOBAL
