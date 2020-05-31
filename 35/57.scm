; Exercise 3.57.  How many additions are performed when we compute the nth Fibonacci number using the definition of fibs based on the add-streams procedure? Show that the number of additions would be exponentially greater if we had implemented (delay <exp>) simply as (lambda () <exp>), without using the optimization provided by the memo-proc procedure described in section 3.5.1.

(define fibs
  (cons-stream 0
               (cons-stream 1
                            (add-streams (stream-cdr fibs)
                                         fibs))))

; Let's say that we want to compute the nth Fibonacci number, i.e. (n-1)-th number in fibs stream. If n = 1 then we need 0 additions, else (n - 2) additions. In other words, it's O(n) order algorithm.

; Consider computing 5th Fibonacci number without memo-proc optimization.
; fibs[0] = 0
; fibs[1] = 1
; fibs[2] = fibs[1] + fibs[0] = 1 + 0 = 1
; fibs[3] = fibs[2] + fibs[1] = fibs[1] + fibs[0] + 1 = 1 + 0 + 1 = 2
; fibs[4] = fibs[3] + fibs[2] = fibs[2] + fibs[1] + fibs[1] + fibs[0] = fibs[1] + fibs[0] + 1 + 1 + 0 = 1 + 0 + 2 = 3

; To compute fibs[n], in general case we have to re-compute fibs[n-1] and fibs[n-2] from scratch, and this problem is recursive. Let's say that A(x) is a number of additions to compute x. A(fibs[n]) = A(fibs[n-1]) + A(fibs[n-2]) + 1 = A(fibs[n-2]) + A(fibs[n-3]) + 1 + A(fibs[n-2]) + 1. For big n, computing fibs[n] is 2<c<3 times as hard as computing fibs[n-2], is 1<c<2 times as hard as computing fibs[n-1]. It's O(c^n) order algorithm.
