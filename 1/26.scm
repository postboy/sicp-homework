; Exercise 1.26.  Louis Reasoner is having great difficulty doing exercise 1.24. His fast-prime? test seems to run more slowly than his prime? test. Louis calls his friend Eva Lu Ator over to help. When they examine Louis's code, they find that he has rewritten the expmod procedure to use an explicit multiplication, rather than calling square:

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (* (expmod base (/ exp 2) m)
                       (expmod base (/ exp 2) m))
                    m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m))))

; ``I don't see what difference that could make,'' says Louis. ``I do.'' says Eva. ``By writing the procedure like that, you have transformed the O(log n) process into a O(n) process.'' Explain. 

; By definition, big O notation is used to specify upper-bound of algorithm complexity. As we have seen in previous analysis, special case for odd numbers doesn't play an important role in overall algorithm complexity. Heart of expmod function is a place where where exponent is even, so we divide it by 2. This heart was changed, so let's concentrate on even numbers handling and compare execution of both implementations on easy example. Let's denote expmod as f.

; Old algorithm: f(8) -> f(4) -> f(2) -> f(1). Clearly, number of iterations is proportional to log2(n).

; New algorithm produces a tree:
;                   f(8)
;         f(4)                f(4)
;    f(2)      f(2)      f(2)      f(2)
; f(1) f(1) f(1) f(1) f(1) f(1) f(1) f(1)
; Clearly, number of steps is proportional to n.
