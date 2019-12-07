; Exercise 3.20.  Draw environment diagrams to illustrate the evaluation of the sequence of expressions <...> using the procedural implementation of pairs given above. (Compare exercise 3.11.)

(load "ch33_common.scm")

(define x (cons 1 2))

; GLOBAL: cons car cdr set-car! x
; E1 | x:1, y:2, set-x!, set-y!, dispatch, link to GLOBAL
; cons -- parameters: x y; body: (define (set-x! v) (set! x v)), link: GLOBAL
; car -- parameters: z; body: (z 'car), link: GLOBAL
; cdr -- parameters: z new-value; body: (z 'cdr), link: GLOBAL
; set-car! -- parameters: z new-value; body: ((z 'set-car!) new-value) z, link: GLOBAL
; x -- parameters: m; body: (cond ((eq? m 'car) x)..., link: E1

(define z (cons x x))

; GLOBAL: cons car cdr set-car! x z
; E1 | x:1, y:2, set-x!, set-y!, dispatch, link to GLOBAL
; E2 | x:x, y:x, set-x!, set-y!, dispatch, link to GLOBAL
; cons -- parameters: x y; body: (define (set-x! v) (set! x v)), link: GLOBAL
; car -- parameters: z; body: (z 'car), link: GLOBAL
; cdr -- parameters: z new-value; body: (z 'cdr), link: GLOBAL
; set-car! -- parameters: z new-value; body: ((z 'set-car!) new-value) z, link: GLOBAL
; x -- parameters: m; body: (cond ((eq? m 'car) x)..., link: E1
; z -- parameters: m; body: (cond ((eq? m 'car) x)..., link: E2

(set-car! (cdr z) 17)

; GLOBAL: cons car cdr set-car! x z
; E1 | x:1, y:2, set-x!, set-y!, dispatch, link to GLOBAL
; E2 | x:x, y:x, set-x!, set-y!, dispatch, link to GLOBAL
; E3 | z:z, link to GLOBAL
; E4 | m:'cdr, link to E2
; cons -- parameters: x y; body: (define (set-x! v) (set! x v)), link: GLOBAL
; car -- parameters: z; body: (z 'car), link: GLOBAL
; cdr -- parameters: z new-value; body: (z 'cdr), link: GLOBAL
; set-car! -- parameters: z new-value; body: ((z 'set-car!) new-value) z, link: GLOBAL
; x -- parameters: m; body: (cond ((eq? m 'car) x)..., link: E1
; z -- parameters: m; body: (cond ((eq? m 'car) x)..., link: E2

; GLOBAL: cons car cdr set-car! x z
; E1 | x:1, y:2, set-x!, set-y!, dispatch, link to GLOBAL
; E2 | x:x, y:x, set-x!, set-y!, dispatch, link to GLOBAL
; E3 | z:x, new-value:17, link to GLOBAL
; E4 | m:'set-car!, link to E1
; cons -- parameters: x y; body: (define (set-x! v) (set! x v)), link: GLOBAL
; car -- parameters: z; body: (z 'car), link: GLOBAL
; cdr -- parameters: z new-value; body: (z 'cdr), link: GLOBAL
; set-car! -- parameters: z new-value; body: ((z 'set-car!) new-value) z, link: GLOBAL
; x -- parameters: m; body: (cond ((eq? m 'car) x)..., link: E1
; z -- parameters: m; body: (cond ((eq? m 'car) x)..., link: E2

; GLOBAL: cons car cdr set-car! x z
; E1 | x:1, y:2, set-x!, set-y!, dispatch, link to GLOBAL
; E2 | x:x, y:x, set-x!, set-y!, dispatch, link to GLOBAL
; E3 | z:x, new-value:17, link to GLOBAL
; E4 | v:17, link to E1
; cons -- parameters: x y; body: (define (set-x! v) (set! x v)), link: GLOBAL
; car -- parameters: z; body: (z 'car), link: GLOBAL
; cdr -- parameters: z new-value; body: (z 'cdr), link: GLOBAL
; set-car! -- parameters: z new-value; body: ((z 'set-car!) new-value) z, link: GLOBAL
; x -- parameters: m; body: (cond ((eq? m 'car) x)..., link: E1
; z -- parameters: m; body: (cond ((eq? m 'car) x)..., link: E2

; GLOBAL: cons car cdr set-car! x z
; E1 | x:17, y:2, set-x!, set-y!, dispatch, link to GLOBAL
; E2 | x:x, y:x, set-x!, set-y!, dispatch, link to GLOBAL
; cons -- parameters: x y; body: (define (set-x! v) (set! x v)), link: GLOBAL
; car -- parameters: z; body: (z 'car), link: GLOBAL
; cdr -- parameters: z new-value; body: (z 'cdr), link: GLOBAL
; set-car! -- parameters: z new-value; body: ((z 'set-car!) new-value) z, link: GLOBAL
; x -- parameters: m; body: (cond ((eq? m 'car) x)..., link: E1
; z -- parameters: m; body: (cond ((eq? m 'car) x)..., link: E2

(assert (car x) 17)

; GLOBAL: cons car cdr set-car! x z
; E1 | x:17, y:2, set-x!, set-y!, dispatch, link to GLOBAL
; E2 | x:x, y:x, set-x!, set-y!, dispatch, link to GLOBAL
; E3 | z:x, link to GLOBAL
; E4 | m:'car, link to E1
; cons -- parameters: x y; body: (define (set-x! v) (set! x v)), link: GLOBAL
; car -- parameters: z; body: (z 'car), link: GLOBAL
; cdr -- parameters: z new-value; body: (z 'cdr), link: GLOBAL
; set-car! -- parameters: z new-value; body: ((z 'set-car!) new-value) z, link: GLOBAL
; x -- parameters: m; body: (cond ((eq? m 'car) x)..., link: E1
; z -- parameters: m; body: (cond ((eq? m 'car) x)..., link: E2

; Everything here is very similar to 3.11.
