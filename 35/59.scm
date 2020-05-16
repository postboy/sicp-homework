; Exercise 3.59.  In section 2.5.3 we saw how to implement a polynomial arithmetic system representing polynomials as lists of terms. In a similar way, we can work with power series, such as <...> represented as infinite streams. We will represent the series a0 + a1*x + a2*x2 + a3*x3 + ··· as the stream whose elements are the coefficients a0, a1, a2, a3, ....

; a. The integral of the series a0 + a1*x + a2*x2 + a3*x3 + ... is the series <...> where c is any constant. Define a procedure integrate-series that takes as input a stream a0, a1, a2, ... representing a power series and returns the stream a0, (1/2)*a1, (1/3)*a2, ... of coefficients of the non-constant terms of the integral of the series. (Since the result has no constant term, it doesn't represent a power series; when we use integrate-series, we will cons on the appropriate constant.)

(load "ch35_common.scm")

(define (integrate-series s)
  (stream-map / s integers))

(assert (stream-part-to-list (integrate-series integers) 5) '(1 1 1 1 1))

; b. The function x -> e^x is its own derivative. This implies that ex and the integral of e^x are the same series, except for the constant term, which is e^0 = 1. Accordingly, we can generate the series for e^x as

(define exp-series
  (cons-stream 1 (integrate-series exp-series)))

(define exp-first-10 '(1 1 1/2 1/6 1/24 1/120 1/720 1/5040 1/40320 1/362880))
(assert (stream-part-to-list exp-series 10) exp-first-10)
(assert (+ (apply + exp-first-10) 0.0) 2.7182815255731922)

; Show how to generate the series for sine and cosine, starting from the facts that the derivative of sine is cosine and the derivative of cosine is the negative of sine:

(define cosine-series
  (cons-stream 1 (stream-map - (integrate-series sine-series))))
(define sine-series
  (cons-stream 0 (integrate-series cosine-series)))

(assert (stream-part-to-list cosine-series 10) '(1 0 -1/2 0 1/24 0 -1/720 0 1/40320 0))
(assert (stream-part-to-list sine-series 10) '(0 1 0 -1/6 0 1/120 0 -1/5040 0 1/362880))
