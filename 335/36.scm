; Exercise 3.36.  Suppose we evaluate the following sequence of expressions in the global environment:

(load "ch335_common.scm")

(define a (make-connector))
(define b (make-connector))
(set-value! a 10 'user)

; At some time during evaluation of the set-value!, the following expression from the connector's local procedure is evaluated:

; (for-each-except setter inform-about-value constraints)

; Draw an environment diagram showing the environment in which the above expression is evaluated.

; Execution is evaluated in E4 described below. As we can see, the values in environment E1 was recently changed by code evaluated in environment E4.

; GLOBAL: set-value! for-each-except inform-about-value make-connector a b
; E1 | value:10, informant:'user, constraints:(), set-my-value, forget-my-value, connect, me, link to GLOBAL
; E2 | value:false, informant:false, constraints:(), set-my-value, forget-my-value, connect, me, link to GLOBAL
; E3 | connector:a, new-value:10, informant:'user, unnamed-var:set-my-value, link to GLOBAL
; E4 | newval:10, setter:'user, link to E1
; set-value! -- parameters: connector, new-value, informant; body: ((connector 'set-value!) new-value informant)), link: GLOBAL
; for-each-except -- parameters: exception, procedure, list; body: (define (loop items)..., link: GLOBAL
; inform-about-value -- parameters: constraint; body: (constraint 'I-have-a-value), link: GLOBAL
; make-connector -- parameters: -; body: (let ((value false)..., link: GLOBAL
; a -- parameters: request; body: (cond ((eq? request 'has-value?)..., link: E1
; b -- parameters: request; body: (cond ((eq? request 'has-value?)..., link: E2
