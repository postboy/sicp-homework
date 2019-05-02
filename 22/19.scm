; Exercise 2.19.  Consider the change-counting program of section 1.2.2. It would be nice to be able to easily change the currency used by the program, so that we could compute the number of ways to change a British pound, for example. As the program is written, the knowledge of the currency is distributed partly into the procedure first-denomination and partly into the procedure count-change (which knows that there are five kinds of U.S. coins). It would be nicer to be able to supply a list of coins to be used for making change.

; Define the procedures first-denomination, except-first-denomination, and no-more? in terms of primitive operations on list structures. Does the order of the list coin-values affect the answer produced by cc? Why or why not?

(load "18.scm")

(define (first-denomination l) (car l))
(define (except-first-denomination l) (cdr l))
(define (no-more? l) (null? l))

(define (cc amount coin-values)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (no-more? coin-values)) 0)
        (else
         (+ (cc amount
                (except-first-denomination coin-values))
            (cc (- amount
                   (first-denomination coin-values))
                coin-values)))))

(define us-coins (list 50 25 10 5 1))
(define uk-coins (list 100 50 20 10 5 2 1 0.5))

(assert 292 (cc 100 us-coins))
(assert 292 (cc 100 (reverse us-coins)))

; As section 1.2.2 said, order of coins does not matter: "The first-denomination procedure takes as input the number of kinds of coins available and returns the denomination of the first kind. Here we are thinking of the coins as arranged in order from largest to smallest, but any order would do as well."

; Here we can see similar situation. Why? Because our code does not directly depend on any particular order of coins.
