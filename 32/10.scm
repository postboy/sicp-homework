; Exercise 3.10.  In the make-withdraw procedure, the local variable balance is created as a parameter of make-withdraw. We could also create the local state variable explicitly, using let, as follows:

(load "ch32_common.scm")

(define (make-withdraw initial-amount)
  (let ((balance initial-amount))
    (lambda (amount)
      (if (>= balance amount)
          (begin (set! balance (- balance amount))
                 balance)
          "Insufficient funds"))))

; Recall from section 1.3.2 that let is simply syntactic sugar for a procedure call: (let ((<var> <exp>)) <body>) is interpreted as an alternate syntax for ((lambda (<var>) <body>) <exp>).

; Use the environment model to analyze this alternate version of make-withdraw, drawing figures like the ones above to illustrate the interactions <...>.

; Let's rewrite make-withdraw without syntactic sugar:
(define (make-withdraw initial-amount)
  ((lambda (balance)
    (lambda (amount)
      (if (>= balance amount)
          (begin (set! balance (- balance amount))
                 balance)
          "Insufficient funds")))
  initial-amount))

; Result of defining make-withdraw in the global environment.

; GLOBAL: make-withdraw
; make-withdraw -- parameters: initial-amount; body: ((lambda (balance)..., link: GLOBAL

(define W1 (make-withdraw 100))

; Result of evaluating (define W1 (make-withdraw 100)).

; GLOBAL: make-withdraw W1
; E1 | initial-amount:100, link to GLOBAL
; E2 | balance:100, link to E1
; make-withdraw -- parameters: initial-amount; body: ((lambda (balance)..., link: GLOBAL
; W1 -- parameters: amount; body: (if (>= balance amount)..., link: E2

(assert (W1 50) 50)

; Environments created by applying the procedure object W1.

; GLOBAL: make-withdraw W1
; E1 | initial-amount:100, link to GLOBAL
; E2 | balance:100, link to E1
; E3 | amount:50, link to E2
; make-withdraw -- parameters: initial-amount; body: ((lambda (balance)..., link: GLOBAL
; W1 -- parameters: amount; body: (if (>= balance amount)..., link: E2

; Environments after the call to W1.

; GLOBAL: make-withdraw W1
; E1 | initial-amount:100, link to GLOBAL
; E2 | balance:50, link to E1
; make-withdraw -- parameters: initial-amount; body: ((lambda (balance)..., link: GLOBAL
; W1 -- parameters: amount; body: (if (>= balance amount)..., link: E2

(define W2 (make-withdraw 100))

; Using (define W2 (make-withdraw 100)) to create a second object.

; GLOBAL: make-withdraw W1 W2
; E1 | initial-amount:100, link to GLOBAL
; E2 | balance:50, link to E1
; E3 | initial-amount:100, link to GLOBAL
; E4 | balance:100, link to E3
; make-withdraw -- parameters: initial-amount; body: ((lambda (balance)..., link: GLOBAL
; W1 -- parameters: amount; body: (if (>= balance amount)..., link: E2
; W2 -- parameters: amount; body: (if (>= balance amount)..., link: E4

(assert (W1 10) 40)
(assert (W2 10) 90)

; Show that the two versions of make-withdraw create objects with the same behavior. How do the environment structures differ for the two versions?

; As we can see, resulting procedures W1 and W2 should have same behavior for two versions of make-withdraw because their bodys and environments are essentially the same. Tests above prove this hypothesis.
; Environment structures for the second version contain extra frames produced by let special form.
