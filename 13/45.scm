; Exercise 1.45.  We saw in section 1.3.3 that attempting to compute square roots by naively finding a fixed point of y -> x/y does not converge, and that this can be fixed by average damping. The same method works for finding cube roots as fixed points of the average-damped y -> x/y^2. Unfortunately, the process does not work for fourth roots -- a single average damp is not enough to make a fixed-point search for y x/y^3 converge. On the other hand, if we average damp twice (i.e., use the average damp of the average damp of y x/y^3) the fixed-point search does converge. Do some experiments to determine how many average damps are required to compute nth roots as a fixed-point search based upon repeated average damping of y x/y^(n-1). Use this to implement a simple procedure for computing nth roots using fixed-point, average-damp, and the repeated procedure of exercise 1.43. Assume that any arithmetic operations you need are available as primitives.

(load "43.scm")

(define (average-damp f)
  (lambda (x) (average x (f x))))

(define (nroot x power damps)
  (fixed-point ((repeated average-damp damps) (lambda (y) (/ x (expt y (dec power)))))
               1.0))

; Following experiments can be very painful to perform from Emacs due to hangs, so I strongly recommend Edwin usage here.

; Let's get minimum damps values that solve the problem in each case. First, we'll give it a try in a naive way: let's suppose that we can wait for an answer.

; This table can be specific for my machine:
; - - 1 1 2 2 1 1 1 1 (powers 2-9)
; 1 3 1 3 1 1 1 1 1 1 (10-19)
; 1 2 2 1 1 1 1 1 1 1 (20-29)
; 1 1 1 - - - - - - - (30-32)
; - - - 3 3 5 - - - - (33-35) - this values may be senseless (see below, along with the commands)
; I don't find this very clarifying.

; Now let's demand more: we want an answer immediately, without waiting for more than a moment.

(nroot (expt 2 2) 2 1)
(nroot (expt 2 3) 3 1)
(nroot (expt 2 4) 4 2)
(nroot (expt 2 5) 5 2)
(nroot (expt 2 6) 6 2)
(nroot (expt 2 7) 7 2)
(nroot (expt 2 8) 8 3)
(nroot (expt 2 9) 9 3)

(nroot (expt 2 10) 10 3)
(nroot (expt 2 11) 11 3)
(nroot (expt 2 12) 12 3)
(nroot (expt 2 13) 13 3)
(nroot (expt 2 14) 14 3)
(nroot (expt 2 15) 15 3)
(nroot (expt 2 16) 16 4)
(nroot (expt 2 17) 17 4)
(nroot (expt 2 18) 18 4)
(nroot (expt 2 19) 19 4)

(nroot (expt 2 20) 20 4)
(nroot (expt 2 21) 21 4)
(nroot (expt 2 22) 22 4)
(nroot (expt 2 23) 23 1)
(nroot (expt 2 24) 24 1)
(nroot (expt 2 25) 25 1)
(nroot (expt 2 26) 26 1)
(nroot (expt 2 27) 27 1)
(nroot (expt 2 28) 28 1)
(nroot (expt 2 29) 29 1)

(nroot (expt 2 30) 30 1)
(nroot (expt 2 31) 31 1)
(nroot (expt 2 32) 32 5)

; "Floating-point overflow" errors force high damps values
(nroot (expt 2 33) 33 5)
(nroot (expt 2 34) 34 5)
(nroot (expt 2 35) 35 5)

; Our sequence is:
; - - 1 1 2 2 2 2 3 3 (powers 2-9)
; 3 3 3 3 3 3 4 4 4 4 (10-19)
; 4 4 4 1 1 1 1 1 1 1 (20-29)
; 1 1 5 - - - - - - - (30-32)
; - - - 5 5 5 - - - - (33-35) - this values may be senseless

; That's much more systematic! As we can see, we need floor(log2(power)) average damps.

(define (log2 x)
  (/ (log x) (log 2)))

(define (nroot-simple x power)
  (define (approx old-approx) (/ x (expt old-approx (dec power))))
  (define (damps-from-power) (floor (log2 power)))
  (fixed-point ((repeated average-damp (damps-from-power)) approx)
               1.0))

(assert (nroot-simple (expt 5 20) 20) 4.999998544071864)
