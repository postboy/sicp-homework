; Exercise 3.27.  Memoization (also called tabulation) is a technique that enables a procedure to record, in a local table, values that have previously been computed. This technique can make a vast difference in the performance of a program. A memoized procedure maintains a table in which values of previous calls are stored using as keys the arguments that produced the values. When the memoized procedure is asked to compute a value, it first checks the table to see if the value is already there and, if so, just returns that value. Otherwise, it computes the new value in the ordinary way and stores this in the table. As an example of memoization, recall from section 1.2.2 the exponential process for computing Fibonacci numbers: <...>. The memoized version of the same procedure is <...> where the memoizer is defined as <...>.

(load "25.scm")

(define (fib n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (else (+ (fib (- n 1))
                 (fib (- n 2))))))

(assert (fib 3) 2)

(define (memoize f)
  (let ((table (make-table)))
    (lambda (x)
      (let ((previously-computed-result (lookup table x)))
        (or previously-computed-result
            (let ((result (f x)))
              (insert! result table x)
              result))))))

(define memo-fib
  (memoize (lambda (n)
             (cond ((= n 0) 0)
                   ((= n 1) 1)
                   (else (+ (memo-fib (- n 1))
                            (memo-fib (- n 2))))))))

(assert (memo-fib 3) 2)

; Draw an environment diagram to analyze the computation of (memo-fib 3). Explain why memo-fib computes the nth Fibonacci number in a number of steps proportional to n. Would the scheme still work if we had simply defined memo-fib to be (memoize fib)?

; GLOBAL: memoize memo-fib
; E1  | f:(lambda (n)..., link to GLOBAL
; E2  | table:(procedure obj, local-table:(*table*)), link to E1
; E3  | x:3, link to E2
; E4  | previously-computed-result:#f, link to E3
; E5  | n:3, link to GLOBAL
; E6  | x:2, link to E2
; E7  | previously-computed-result:#f, link to E6
; E8  | n:2, link to GLOBAL
; E9  | x:1, link to E2
; E10 | previously-computed-result:#f, link to E9
; E11 | n:1, link to GLOBAL
; memoize -- parameters: f; body: (let ((table (make-table)))..., link: GLOBAL
; memo-fib -- parameters: x; body: (let ((previously-computed-result (lookup table x)))..., link: GLOBAL

; (memo-fib 1) will be remembered in E10.

; GLOBAL: memoize memo-fib
; E1  | f:(lambda (n)..., link to GLOBAL
; E2  | table:(procedure obj, local-table:(*table* (1 1))), link to E1
; E3  | x:3, link to E2
; E4  | previously-computed-result:#f, link to E3
; E5  | n:3, link to GLOBAL
; E6  | x:2, link to E2
; E7  | previously-computed-result:#f, link to E6
; E8  | n:2, link to GLOBAL
; E9  | x:0, link to E2
; E10 | previously-computed-result:#f, link to E9
; E11 | n:0, link to GLOBAL
; memoize -- parameters: f; body: (let ((table (make-table)))..., link: GLOBAL
; memo-fib -- parameters: x; body: (let ((previously-computed-result (lookup table x)))..., link: GLOBAL

; (memo-fib 0) will be remembered in E10.

; GLOBAL: memoize memo-fib
; E1  | f:(lambda (n)..., link to GLOBAL
; E2  | table:(procedure obj, local-table:(*table* (0 0) (1 1))), link to E1
; E3  | x:3, link to E2
; E4  | previously-computed-result:#f, link to E3
; E5  | n:3, link to GLOBAL
; E6  | x:2, link to E2
; E7  | previously-computed-result:#f, link to E6
; memoize -- parameters: f; body: (let ((table (make-table)))..., link: GLOBAL
; memo-fib -- parameters: x; body: (let ((previously-computed-result (lookup table x)))..., link: GLOBAL

; (memo-fib 2) will be remembered in E7.

; GLOBAL: memoize memo-fib
; E1  | f:(lambda (n)..., link to GLOBAL
; E2  | table:(procedure obj, local-table:(*table*) (2 1) (0 0) (1 1)), link to E1
; E3  | x:3, link to E2
; E4  | previously-computed-result:#f, link to E3
; E5  | n:3, link to GLOBAL
; E6  | x:1, link to E2
; E7  | previously-computed-result:1, link to E6
; memoize -- parameters: f; body: (let ((table (make-table)))..., link: GLOBAL
; memo-fib -- parameters: x; body: (let ((previously-computed-result (lookup table x)))..., link: GLOBAL

; GLOBAL: memoize memo-fib
; E1  | f:(lambda (n)..., link to GLOBAL
; E2  | table:(procedure obj, local-table:(*table*) (2 1) (0 0) (1 1)), link to E1
; E3  | x:3, link to E2
; E4  | previously-computed-result:#f, link to E3
; memoize -- parameters: f; body: (let ((table (make-table)))..., link: GLOBAL
; memo-fib -- parameters: x; body: (let ((previously-computed-result (lookup table x)))..., link: GLOBAL

; (memo-fib 3) will be remembered in E4.

; GLOBAL: memoize memo-fib
; E1  | f:(lambda (n)..., link to GLOBAL
; E2  | table:(procedure obj, local-table:(*table*) (3 2) (2 1) (0 0) (1 1)), link to E1
; memoize -- parameters: f; body: (let ((table (make-table)))..., link: GLOBAL
; memo-fib -- parameters: x; body: (let ((previously-computed-result (lookup table x)))..., link: GLOBAL

; memo-fib computes the nth Fibonacci number in a number of steps proportional to n because memo-fib avoids repeating of same computations via memoization. In worst-case scenario (when table is empty) we have to compute (memo-fib (n-1))...(memo-fib 0) for computing (memo-fib n), but we do each of this computations only once. We have to make O(n) addition operations, O(n) write operations with table and O(n) read operations with table. After (memo-fib n), table contains values of (memo-fib n)...(memo-fib 0).

; In general, this scheme wouldn't work such effectively if we had simply defined memo-fib to be (memoize fib). In this case memoization would work only for outer level of computation. In worst-case scenario (when table is empty) we have to compute (memo-fib (n-1))...(memo-fib 0) for computing (memo-fib n), and we would generally do each of this computations many times. After (memo-fib n), table would contain only value of (memo-fib n).
